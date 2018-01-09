//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.auths;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.replys.UIA;
import beartek.matrix_im.client.types.enums.Auths;

@:keep class M_login_password extends Auth {
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
      request = UIA.add_auth(request, this.pet);
      this.send_request(request, this.on_response);
    } else {
      throw 'Stage not completed';
    }
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
