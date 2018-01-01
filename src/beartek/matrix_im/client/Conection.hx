//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client;

import haxe.http.HttpRequest;
import haxe.http.Url;
import beartek.matrix_im.client.handlers.*;
import beartek.matrix_im.client.Check_reply;
import beartek.matrix_im.client.types.replys.Error;


class Conection {
  public var session : Session;

  var responses_handlers : Map<Int,Array<Int -> Dynamic -> Bool>> = new Map();
  var status : Int = 0;

  public function new() {
    this.session = new Session(this.on_responses, this.send_request);

  }

  public static function make_request( method : String, url : String, data : Dynamic ) : HttpRequest {
    var request = new HttpRequest();
    request.method = method;
    request.url = new Url(url);
    request.headers.set("Content-Type", "application/json");
    request.data = haxe.Json.stringify(data);
    return request;
  }

  private function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void ) : Void {
    request.send({onStatus: function( status : Int )  {
                    this.status = status;
                  },
                  onData: function( data : Dynamic ) : Void {
                    on_response(this.status, data);
                  },
                  onError: function( error : String, ?data : String ) : Void {
                    this.on_fatal_error(error);
                  }});
  }

  private function on_responses( status_code : Int, response : Dynamic ) : Bool {
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
    case _:
      this.on_fatal_error('Unexcepted status code recived');
      return false;
    }
  }

  dynamic function on_error( error : Error ) {
    trace( 'Error: ' + error );
  }

  dynamic function on_fatal_error( error : String ) {
    throw error;
  }

}
