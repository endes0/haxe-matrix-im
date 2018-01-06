//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client;

import com.akifox.asynchttp.*;
import beartek.matrix_im.client.handlers.*;
import beartek.matrix_im.client.Check_reply;
import beartek.matrix_im.client.types.replys.Error;


class Conection {
  public var session : Session;
  var responses_handlers : Map<Int,Array<Int -> Dynamic -> Bool>> = new Map();

  public function new( server_url : String ) {
    this.session = new Session(this.on_responses, this.send_request, server_url);

  }

  public static function make_request( method : String, url : String, data : Dynamic ) : HttpRequest {
    var request = new HttpRequest({
      url: url,
      method: method,
      contentType: "application/json",
      content: haxe.Json.stringify(data)
    });
    return request;
  }

  private function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void ) : Void {
    if( this.session.access_token != null ) {
      request.url = new URL(request.url.toString() + '?access_token=' + this.session.access_token);
    }
    #if debug
    trace( 'sending request: ' + request );
    #end
    request.callback = function( response : HttpResponse ) : Void {
      #if debug
      trace( 'callback called' );
      #end
      if( response.error != '' ) {
        throw response.error;
      }
      if( this.on_responses(response.status, response.toJson()) ) {
        on_response(response.status, response.toJson());
      }
    };
    request.async = false;
    request.send();
  }

  private function on_responses( status_code : Int, response : Dynamic ) : Bool {
    #if debug
    trace( 'recived reply: ' + status_code + ', ' + response );
    #end
    switch status_code {
    case 400 | 403 | 429 | 404:
      if( Check_reply.is_error(response) ) {
        this.on_error(response);
      } else {
        this.on_fatal_error('Invalid error recived');
      }

      return false;
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
      this.on_fatal_error('Unexcepted status code recived');
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
