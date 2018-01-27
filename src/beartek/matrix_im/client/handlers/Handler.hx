//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;

class Handler {
  var server : String;

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    this.on_responses = on_responses;
    this.send_request = send_request;
    this.server = server;
  }

  dynamic function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void, ignore_errors : Bool = false ) : Void {
    throw 'Handler created erroniusly';
  }

  dynamic function on_responses( status_code : Int, response : Dynamic, ignore_errors : Bool = false ) : Bool {
    return true;
  }

}
