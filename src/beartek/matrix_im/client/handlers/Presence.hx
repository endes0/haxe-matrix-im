//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.User;
import beartek.matrix_im.client.types.replys.User_status;

class Presence extends Handler {
  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
  }

  public function set_presence(user: User, presence: beartek.matrix_im.client.types.enums.Presences, ?status: String, ?on_response: Void -> Void) : Void {
    if(status == null) {
        this.send_request(Conection.make_request(HttpMethod.PUT, server + '/_matrix/client/r0/presence/' + user + '/status', {presence: presence}), function ( status : Int, data: Dynamic ) : Void {
            on_response();
        }
    } else {
        this.send_request(Conection.make_request(HttpMethod.PUT, server + '/_matrix/client/r0/presence/' + user + '/status', {presence: presence, status_msg: status}), function ( status : Int, data: Dynamic ) : Void {
            on_response();
        }
    }
  }

public function get_presence(user: User, ?on_response: User_status -> Void) : Void {
    this.send_request(Conection.make_request(HttpMethod.GET, server + '/_matrix/client/r0/presence/' + user + '/status', null), function ( status : Int, data: User_status ) : Void {
        on_response(data);
    }
  }

}
