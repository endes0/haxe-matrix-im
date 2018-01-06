//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.User;
import beartek.matrix_im.client.types.enums.Auths;
import beartek.matrix_im.client.types.replys.UIA;
import beartek.matrix_im.client.auths.Auth;

class Session {
  public var user : User;
  public var device : String;
  public var access_token : String;

  var server : String;

  public function new( on_responses : Int -> Dynamic -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> Void, server : String ) {
    this.on_responses = on_responses;
    this.send_request = send_request;
    this.server = server;
  }

  public function login_with_pass( user : String, password : String, display_name : String = 'Matrix client on haxe', on_response : {access_token: String, device_id: String, home_server: String, user_id: String} -> Void ) : Void {
    var data = {
      initial_device_display_name: display_name,
      password: password,
      type: Auths.Password,
      user: user
    };
    this.send_request(Conection.make_request(HttpMethod.POST, server + '/_matrix/client/r0/login', data ), function( code : Int, data : {access_token: String, device_id: String, home_server: String, user_id: String} ) : Void {
      this.access_token = data.access_token;
      this.device = data.device_id;
      this.user = new User(data.user_id);
      on_response(data);
    });
  }

  public function login_with_email( email : String, password : String, display_name : String = 'Matrix client on haxe', on_response : {access_token: String, device_id: String, home_server: String, user_id: String} -> Void ) : Void {
    var data = {
      address: email,
      initial_device_display_name: display_name,
      medium: 'email',
      password: password,
      type: Auths.Password
    };
    this.send_request(Conection.make_request(HttpMethod.POST, server + '/_matrix/client/r0/login', data ), function( code : Int, data : {access_token: String, device_id: String, home_server: String, user_id: String} ) : Void {
      this.access_token = data.access_token;
      this.device = data.device_id;
      this.user = new User(data.user_id);
      on_response(data);
    });
  }

  public function login_with_token( token : String, display_name : String = 'Matrix client on haxe', on_response : {access_token: String, device_id: String, home_server: String, user_id: String} -> Void ) : Void {
    var data = {
      initial_device_display_name: display_name,
      token: token,
      type: Auths.Token
    };
    this.send_request(Conection.make_request(HttpMethod.POST, server + '/_matrix/client/r0/login', data ), function( code : Int, data : {access_token: String, device_id: String, home_server: String, user_id: String} ) : Void {
      this.access_token = data.access_token;
      this.device = data.device_id;
      this.user = new User(data.user_id);
      on_response(data);
    });
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

  dynamic function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void ) : Void {
    throw 'Handler created erroniusly';
  }

  dynamic function on_responses( status_code : Int, response : Dynamic ) : Bool {
    return true;
  }
}
