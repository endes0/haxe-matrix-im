//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.auths;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.replys.UIA;

@:keep class Unknow_auth implements Auth {
  public var request : HttpRequest;
  var session : String;
  var auth : String;

  public function new( session : String, auth : String ) {
    this.session = session;
    this.auth = auth;
  }

  public inline function get_fallback( server_url : String ) : String {
    if( server_url.charAt(server_url.length-1) == '/' ) {
      server_url = server_url.substr(0, server_url.length-2);
    }

    return server_url + '/_matrix/client/r0/auth/' + this.auth + '/fallback/web?session=' + this.session;
  }

  public function make_pet() : Void {
    request.content = haxe.Json.stringify({session: this.session});
    this.send_request(request, this.on_response);
  };

  dynamic public function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void ) : Void {};
  dynamic public function on_response( status_code : Int, response : Dynamic ) : Void {};

}
