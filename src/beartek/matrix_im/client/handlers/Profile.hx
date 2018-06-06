//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.Version;
import beartek.matrix_im.client.types.User;

class Profile extends Handler {

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
  }

  public inline function set_displayname( name : String, user : User, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('PUT', this.server + '/_matrix/client/r0/profile/' + user + '/displayname', {displayname: name}), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function get_displayname( user : User, on_response : String -> Void ) : Void {
    this.send_request(Conection.make_request('GET', this.server + '/_matrix/client/r0/profile/' + user + '/displayname', null), function( status : Int, data : Dynamic ) : Void {
      on_response(data.displayname);
    });
  }

  public inline function set_avatar( url : String, user : User, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('PUT', this.server + '/_matrix/client/r0/profile/' + user + '/avatar_url', {avatar_url: url}), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function get_avatar( user : User, on_response : String -> Void ) : Void {
    this.send_request(Conection.make_request('GET', this.server + '/_matrix/client/r0/profile/' + user + '/avatar_url', null), function( status : Int, data : Dynamic ) : Void {
      on_response(data.avatar_url);
    });
  }

  public inline function get_profile( user : User, on_response : String -> String -> Void ) : Void {
    this.send_request(Conection.make_request('GET', this.server + '/_matrix/client/r0/profile/' + user, null), function( status : Int, data : Dynamic ) : Void {
      on_response(data.displayname, data.avatar_url);
    });
  }
}
