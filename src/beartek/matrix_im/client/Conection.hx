//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client;

import com.akifox.asynchttp.*;
import beartek.matrix_im.client.handlers.*;
import beartek.matrix_im.client.Check_reply;
import beartek.matrix_im.client.types.replys.Error;
import beartek.matrix_im.client.types.replys.Login_data;

class Conection {
  public var server : Server_adm;
  public var session : Session;
  public var account : Account;
  public var filters : Filters;
  public var sync : Sync;
  public var rooms : Rooms;
  public var profile : Profile;

  public var server_url(default, null) : String;
  var responses_handlers : Map<Int,Array<Int -> Dynamic -> Bool>> = new Map();

  public function new( server_url : String ) {
    this.server_url = server_url;

    this.session = new Session(this.on_responses, this.send_request, server_url);

    this.server = new Server_adm(this.on_responses, this.send_request, server_url);
    this.server.get_versions();

    this.account = new Account(this.on_responses, this.send_request, server_url);
    this.account.on_login_data = function(l: Login_data) {
      this.session.fallback_handler(l)
    }

    this.filters = new Filters(this.on_responses, this.send_request, server_url);

    this.sync = new Sync(this.on_responses, this.send_request, server_url);

    this.rooms = new Rooms(this.on_responses, this.send_request, server_url);
    this.session.onopen(function (t:String) {
      this.rooms.update_joined_room();
    });

    this.profile = new Profile(this.on_responses, this.send_request, server_url);
  }

  public static function to_object_map<T>( o : Dynamic ) : Map<String,T> {
    var result : Map<String,T> = new Map();
    for( field in Reflect.fields(o) ) {
      result.set(field,Reflect.field(o, field));
    }
    return result;
  }

  public static function make_request( method : String, url : String, data : Dynamic ) : HttpRequest {
    var request = new HttpRequest({
      url: url,
      method: method,
      contentType: if(data != null) "application/json" else null,
      content: if(data != null) haxe.Json.stringify(data) else null
    });
    return request;
  }

  private function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void, ignore_errors : Bool = false ) : Void {
    if( this.session.access_token != null ) {
    if( request.url.querystring == '' ) {
      request.url = new URL(request.url.toString() + '?access_token=' + this.session.access_token);
    } else {
      request.url = new URL(request.url.toString() + '&access_token=' + this.session.access_token);
    }
    }
    #if debug
    trace( 'sending request: ' + request.content );
    #end
    request.callback = function( response : HttpResponse ) : Void {
      #if debug
      trace( 'callback called' );
      #end
      if( this.on_responses(response.status, response.toJson(), ignore_errors) ) {
        on_response(response.status, response.toJson());
      }
    };
    request.async = false;
    request.send();
  }

  private function on_responses( status_code : Int, response : Dynamic, ignore_errors : Bool = false ) : Bool {
    #if debug
    trace( 'recived reply: ' + status_code + ', ' + response );
    #end
    switch status_code {
    case 400 | 403 | 429 | 404:
      if( Check_reply.is_error(response) ) {
        this.on_error(response);
      }

      if(ignore_errors) return true else return false;
    case 401 | 200 | 302 :
      var is_all_true : Bool = true;
      if( responses_handlers[status_code] != null ) {
        for( func in responses_handlers[status_code] ) {
          if( func(status_code, response) == false ) {
            is_all_true = false;
          }
        }
        return is_all_true;
      } else {
        return true;
      }
    case 0:
      return false;
    case _:
      this.on_fatal_error('Unexcepted status code recived: ' + status_code + ', error: ' + response);
      return false;
    }
  }

  public dynamic function on_error( error : Error ) {
    trace( 'Error: ' + error );
  }

  public dynamic function on_fatal_error( error : String ) {
    throw error;
  }

}
