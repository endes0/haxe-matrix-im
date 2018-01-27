//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.User;
import beartek.matrix_im.client.types.enums.Auths;
import beartek.matrix_im.client.types.replys.UIA;
import beartek.matrix_im.client.types.replys.Login_data;
import beartek.matrix_im.client.auths.Auth;

class Session extends Handler {
  public var user : User;
  public var device : String;
  public var access_token : String;

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
  }

  public function login_with_pass( user : String, password : String, display_name : String = 'Matrix client on haxe', on_response : Login_data -> Void ) : Void {
    var data = {
      initial_device_display_name: display_name,
      password: password,
      type: Auths.Password,
      user: user
    };
    this.send_request(Conection.make_request(HttpMethod.POST, server + '/_matrix/client/r0/login', data ), function( code : Int, data : Login_data ) : Void {
      this.fallback_handler(data, on_response);
    });
  }

  public function login_with_email( email : String, password : String, display_name : String = 'Matrix client on haxe', on_response : Login_data -> Void ) : Void {
    var data = {
      address: email,
      initial_device_display_name: display_name,
      medium: 'email',
      password: password,
      type: Auths.Password
    };
    this.send_request(Conection.make_request(HttpMethod.POST, server + '/_matrix/client/r0/login', data ), function( code : Int, data : Login_data ) : Void {
      this.fallback_handler(data, on_response);
    });
  }

  public function login_with_token( token : String, display_name : String = 'Matrix client on haxe', on_response : Login_data -> Void ) : Void {
    var data = {
      initial_device_display_name: display_name,
      token: token,
      type: Auths.Token
    };
    this.send_request(Conection.make_request(HttpMethod.POST, server + '/_matrix/client/r0/login', data ), function( code : Int, data : Login_data ) : Void {
      this.fallback_handler(data, on_response);
    });
  }

  public function get_fallback() : String {
    return server + '/_matrix/static/client/login/';
  }

  public function fallback_handler( response : Login_data, on_response : Login_data -> Void ) : Void {
    this.access_token = response.access_token;
    this.device = response.device_id;
    this.user = new User(response.user_id);
    on_response(response);
  }

  public function logout( on_logout : Void -> Void ) : Void {
    this.send_request(Conection.make_request(HttpMethod.POST, server + '/_matrix/client/r0/logout', null),function ( code : Int, data : Dynamic ) : Void {
      if( code == 200 ) {
        this.access_token = null;
        this.device = null;
        this.user = null;
        on_logout();
      } else {
        throw 'Invalid status code on logout';
      }
    });
  }
}
