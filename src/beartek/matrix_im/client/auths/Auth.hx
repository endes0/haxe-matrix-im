//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.auths;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.replys.UIA;

interface Auth {
  public var request : HttpRequest;
  public function make_pet() : Void;
  dynamic function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void ) : Void;
  dynamic public function on_response( status_code : Int, response : Dynamic ) : Void;
}
