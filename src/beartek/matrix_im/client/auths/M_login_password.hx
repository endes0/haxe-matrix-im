//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.auths;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.replys.UIA;
import beartek.matrix_im.client.types.enums.Auths;

@:keep class M_login_password implements Auth {
  public var request : HttpRequest;
  var session : String;
  var pet : Pet;

  public function new( session : String, params : Dynamic ) {
    if( params != null ) {
      throw 'unknow params recived: ' + params;
    }

    this.session = session;
  }

  public function login_with_user( user : String, password : String ) : Void {
    this.pet = {
      type: Password,
      user: user,
      password: password,
      session: this.session
    }
  }

  public function login_with_medium( medium : String, address : String, password : String ) : Void {
    this.pet = {
      type: Password,
      medium: medium,
      address: address,
      password: password,
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

private typedef Pet = {
  var type : Auths;
  @:optional var user : String;
  @:optional var medium : String;
  @:optional var address : String;
  var password : String;
  var session : String;
}
