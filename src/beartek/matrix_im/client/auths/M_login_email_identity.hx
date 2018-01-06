//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.auths;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.replys.UIA;
import beartek.matrix_im.client.types.enums.Auths;

@:keep class M_login_email_identity implements Auth {
  public var request : HttpRequest;
  var session : String;
  var pet : Dynamic;

  public function new( session : String, params : Dynamic ) {
    if( params != null ) {
      throw 'unknow params recived: ' + params;
    }

    this.session = session;
  }

  public function login( server : String, session : String, client_secret : String ) : Void {
    this.pet = {
      type: Email,
      threepidCreds: [{sid: session, client_secret: client_secret, id_server: server}],
      session: this.session
    }
  }

  public function make_pet() : Void {
    if( pet != null ) {
      request.content = haxe.Json.stringify(this.pet);
      this.send_request(request, this.on_response);
    } else {
      throw 'Stage not completed';
    }
  };

  dynamic public function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void ) : Void {};
  dynamic public function on_response( status_code : Int, response : Dynamic ) : Void {
  };
}
