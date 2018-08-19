//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.replys.Turn_Servers;
import m.call.Answer;

class Voip extends Handler {
  public var turn_servers : Array<String>;
  public var turn_username : String;
  public var turn_password : String;

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
  }

  public function get_turn_servers(?on_response: Turn_Servers -> Void) : Void {
    this.send_request(Conection.make_request(HttpMethod.GET, server + '/_matrix/client/r0/voip/turnServer', null), function ( status : Int, data: Turn_Servers ) : Void {
      on_response(data);
    });
  }

  public function accept_call(call_id: String, other_call_id: String): Bool {
      for(i in 0...call_id.length -1) {
          if(call_id.charCodeAt(i) > other_call_id.charCodeAt(i)) {
              return false;
          } else if(call_id.charCodeAt(i) < other_call_id.charCodeAt(i)) {
              return true;
          }
      }
      return null;
  }

  public function update_turn() {
    this.get_turn_servers(function(data: Turn_Servers) {
        this.turn_username = data.username;
        this.turn_password = data.password;
        this.turn_servers = data.uris;

        haxe.Timer.delay(update_turn, if(data.ttl != null && data.ttl != 0) data.ttl else 3600000);
    });
  }
}
