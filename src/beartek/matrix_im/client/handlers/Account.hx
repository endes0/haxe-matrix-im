//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.enums.User_kind;
import beartek.matrix_im.client.types.enums.Auths;
import beartek.matrix_im.client.types.replys.Login_data;
import beartek.matrix_im.client.types.replys.UIA;
import beartek.matrix_im.client.types.replys.Threepid;
import beartek.matrix_im.client.types.User;
import beartek.matrix_im.client.types.Room;
import beartek.matrix_im.client.types.Device;
import beartek.matrix_im.client.auths.Auth;

class Account extends Handler {
  public dynamic function on_login_data(data: Login_data) {
    trace('This function must be repalced');
  }

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
  }

  public function register( kind : User_kind = User, username : String, password : String, bind_email : Bool, display_name : String = 'Matrix client on haxe', on_response : Login_data -> Void, on_stage : Auths -> Auth -> Void, ?stage_selector : Array<Array<Auths>> -> Int ) : Void {
    if( !check_password(password) ) {
      throw 'Password too weak';
    }

    var request = {bind_email: bind_email, username: username, password: password, display_name : display_name};
    var fallback = function(l: Login_data) {
      on_login_data(l);
      on_response(l);
    };

    this.send_request(Conection.make_request('POST', server + '/_matrix/client/r0/register?kind=' + kind, request), function( status : Int, response : Dynamic ) : Void {
      if( Check_reply.is_UIA(response) ) {
        var data : UIA = new UIA(response);
        var request = Conection.make_request('POST', server + '/_matrix/client/r0/register?kind=' + kind, request);

        if( stage_selector != null ) {
          data.select_flow(stage_selector(data.get_flows()));
        } else {
          data.select_flow(UIA.fast_flow(data.get()));
        }

        data.start(on_stage, fallback, request, this.send_request);
      } else {
        throw 'Error on trying UIA: ' + response;
      }
    }, true);
  }

  public function validate_register_email( ?id_server : String, email : String, attemp : Int = 1, ?secret : String, on_response : Void -> Void ) : Void {
    this.email_token(id_server, email, attemp, secret, on_response, '/_matrix/client/r0/register/email/requestToken');
  }

  public function change_password( new_password : String, on_response : Null<Dynamic> -> Void, on_stage : Auths -> Auth -> Void, ?stage_selector : Array<Array<Auths>> -> Int ) : Void {
    if( !check_password(new_password) ) {
      throw 'Password too weak';
    }

    var request = {new_password: new_password};

    this.send_request(Conection.make_request('POST', server + '/_matrix/client/r0/account/password', request), function( status : Int, response : Dynamic ) : Void {
      if( Check_reply.is_UIA(response) ) {
        var data : UIA = new UIA(response);
        var request = Conection.make_request('POST', server + '/_matrix/client/r0/account/password', request);

        if( stage_selector != null ) {
          data.select_flow(stage_selector(data.get_flows()));
        } else {
          data.select_flow(UIA.fast_flow(data.get()));
        }

        data.start(on_stage, on_response, request, this.send_request);
      } else {
        throw 'Error on trying UIA';
      }
    }, true);
  }

  public function validate_password_email( ?id_server : String, email : String, attemp : Int = 1, ?secret : String, on_response : Void -> Void ) : Void {
    this.email_token(id_server, email, attemp, secret, on_response, '/_matrix/client/r0/account/password/email/requestToken');
  }

  public function deactivate( on_response : Null<Dynamic> -> Void, on_stage : Auths -> Auth -> Void, ?stage_selector : Array<Array<Auths>> -> Int ) : Void {
    this.send_request(Conection.make_request('POST', server + '/_matrix/client/r0/account/deactivate', {}), function( status : Int, response : Dynamic ) : Void {
      if( Check_reply.is_UIA(response) ) {
        var data : UIA = new UIA(response);
        var request = Conection.make_request('POST', server + '/_matrix/client/r0/account/deactivate', {});

        if( stage_selector != null ) {
          data.select_flow(stage_selector(data.get_flows()));
        } else {
          data.select_flow(UIA.fast_flow(data.get()));
        }

        data.start(on_stage, on_response, request, this.send_request);
      } else {
        throw 'Error on trying UIA';
      }
    }, true);
  }


  public function get_devices( on_response : Array<Device> -> Void ) : Void {
    this.send_request(Conection.make_request('GET', server + '/_matrix/client/r0/devices', null), function( status : Int, data : {devices: Array<Device>} ) : Void {
      on_response(data.devices);
    });
  }

  public function get_device(id: String, on_response : Device -> Void) : Void {
    this.send_request(Conection.make_request('GET', server + '/_matrix/client/r0/devices/' + id, null), function( status : Int, data : Device ) : Void {
      on_response(data);
    });
  }

  public function set_device_name(id: String, name: String, on_response : Void -> Void) : Void {
    this.send_request(Conection.make_request('PUT', server + '/_matrix/client/r0/devices/' + id, {display_name: name}), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public function delete_device( id: String, on_response : Null<Dynamic> -> Void, on_stage : Auths -> Auth -> Void, ?stage_selector : Array<Array<Auths>> -> Int ) : Void {
    this.send_request(Conection.make_request('DELETE', server + '/_matrix/client/r0/devices/' + id, null), function( status : Int, response : Dynamic ) : Void {
      if( Check_reply.is_UIA(response) ) {
        var data : UIA = new UIA(response);
        var request = Conection.make_request('DELETE', server + '/_matrix/client/r0/devices/' + id, {});

        if( stage_selector != null ) {
          data.select_flow(stage_selector(data.get_flows()));
        } else {
          data.select_flow(UIA.fast_flow(data.get()));
        }

        data.start(on_stage, on_response, request, this.send_request);
      } else {
        throw 'Error on trying UIA';
      }
    }, true);
  }


  public function get_3pid( on_response : Array<Threepid> -> Void ) : Void {
    this.send_request(Conection.make_request('GET', server + '/_matrix/client/r0/account/3pid', null), function( status : Int, data : {threepids: Array<Threepid>} ) : Void {
      on_response(data.threepids);
    });
  }

  public function add_3pid( id_server : String, sid : String, secret : String, bind = false, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('POST', server + '/_matrix/client/r0/account/3pid', {three_pid_creds: {client_secret: secret, id_server: id_server, sid: sid}, bind: bind}), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public function validate_added_email( ?id_server : String, email : String, attemp : Int = 1, ?secret : String, on_response : Void -> Void ) : Void {
    this.email_token(id_server, email, attemp, secret, on_response, '/_matrix/client/r0/account/3pid/email/requestToken');
  }

  public function add_data( user : User, type : String, data: Dynamic, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('PUT', server + '/_matrix/client/r0/user/' + user + '/account_data/' + type, data), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public function add_room_data( user : User, room: Room, type : String, data: Dynamic, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('PUT', server + '/_matrix/client/r0/user/' + user + '/rooms/' + room + '/account_data/' + type, data), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public function whoami( on_response : User -> Void ) : Void {
    trace( 'Use Conection.session.user instead of Conection.account.whoami' );
    this.send_request(Conection.make_request('GET', server + '/_matrix/client/r0/account/whoami', null), function( status : Int, data : {user_id: String} ) : Void {
      on_response( new User(data.user_id) );
    });
  }

  private function email_token( ?id_server : String, email : String, attemp : Int = 1, ?secret : String, on_response : Void -> Void, url : String ) : Void {
    if(secret == null) {
      secret = '';
      for( i in 0...Std.random(15) + 10 ) {
        secret += String.fromCharCode(Std.random(254) + 1);
      }
    }

    this.send_request(Conection.make_request('POST', server + url, {
      id_server: id_server,
      client_secret: secret,
      email: email,
      send_attemp: attemp}), function( status : Int, response : Dynamic ) : Void {
        on_response();
      });
  }

  private inline function check_password( p : String ) : Bool {
    if( p.length < 8 && !~/[A-Z]/g.match(p) && !~/[a-z]/g.match(p) ) {
      return false;
    } else {
      return true;
    }
  }
}
