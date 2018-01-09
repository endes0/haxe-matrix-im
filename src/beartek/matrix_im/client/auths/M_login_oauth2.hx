//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.auths;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.replys.UIA;

@:keep class M_login_oauth2 extends Auth {
  var session : String;
  var oauth_uri : String;

  public function new( session : String, params : {uri : String} ) {
    if( params.uri == null ) {
      throw 'Invalid oauth URI recived';
    }
    this.session = session;
    this.oauth_uri = params.uri;
  }

  public inline function get_uri() : String {
    return this.oauth_uri;
  }

  public function make_pet() : Void {
    request = UIA.add_auth(request, {session: this.session});
    this.send_request(request, this.on_response);
  };

}
