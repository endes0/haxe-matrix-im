//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import haxe.http.HttpRequest;

class Session {

  public function new( on_responses : Int -> Dynamic -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> Void ) {
    this.on_responses = on_responses;
    this.send_request = send_request;
  }

  dynamic function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void ) : Void {
    throw 'Handler created erroniusly';
  }

  dynamic function on_responses( status_code : Int, response : Dynamic ) : Bool {
    return true;
  }
}
