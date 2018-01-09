//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.auths;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.replys.UIA;
import beartek.matrix_im.client.types.enums.Auths;

@:keep class M_login_dummy extends Auth {
  var session : String;
  var auth : String;

  public function new( session : String, params : Dynamic ) {
    if( params != null ) {
      throw 'unknow params recived: ' + params;
    }

    this.session = session;
  }

  public function make_pet() : Void {
    request = UIA.add_auth(request, {type: Dummy, session: this.session});
    this.send_request(request, this.on_response);
  };

}
