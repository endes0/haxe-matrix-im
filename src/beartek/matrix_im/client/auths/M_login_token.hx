//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.auths;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.replys.UIA;
import beartek.matrix_im.client.types.enums.Auths;

@:keep class M_login_token implements Auth {
  public var request : HttpRequest;
  public var nonce : String;
  var session : String;
  var pet : Dynamic;

  public function new( session : String, params : Dynamic ) {
    if( params != null ) {
      throw 'unknow params recived: ' + params;
    }

    this.session = session;

    for( a in 0...Math.floor(Math.random()*120) ) {
      nonce += String.fromCharCode(Math.floor(Math.random()*255));
    }
  }

  public function login_with_token( token : String, ?nonce : String ) : Void {
    if( nonce != null ) {
      this.nonce = nonce;
    }
    this.pet = {
      type: Token,
      token: token,
      txn_id: this.nonce,
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
