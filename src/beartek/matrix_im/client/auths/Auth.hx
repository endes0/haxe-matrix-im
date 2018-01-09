//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.auths;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.replys.UIA;

@:keep class Auth {
  public var request : HttpRequest;
  dynamic public function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void, ignore_errors : Bool = true ) : Void {};
  dynamic public function on_response( status_code : Int, response : Dynamic ) : Void {};
}
