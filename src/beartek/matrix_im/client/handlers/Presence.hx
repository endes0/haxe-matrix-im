//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.User;
import beartek.matrix_im.client.types.enums.event.Types;
import beartek.matrix_im.client.types.replys.User_status;

class Presence extends Handler {
  public var user: User;  
  public var list(default, set): Map<User, User_status>;

  public function set_list(list: Map<User, User_status>): Map<User, User_status> {
      var remove = [];
      var add = [];
      for(user in list.keys()) {
          if(list[user] == null && this.list.exists(user)) {
              remove.push(user);
          } else if(list[user] == null && !this.list.exists(user)) {
              add.push(user);
          }
      }
      this.edit_list(this.user, add, remove);
      this.list = list;
      return list;
  }

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

public function edit_list(user: User, add: Array<User>, remove: Array<User>, ?on_response: Void -> Void) : Void {
    this.send_request(Conection.make_request(HttpMethod.POST, server + '/_matrix/client/r0/presence/list/' + user , {invite: add, drop: remove}), function ( status : Int, data: Dynamic ) : Void {
        on_response();
    }
 }

public function update_list(user: User, time: Int, ?on_response: Array<{content: User_status, type: Types}> -> Void) : Void {
    this.send_request(Conection.make_request(HttpMethod.GET, server + '/_matrix/client/r0/presence/list/' + user , null), function ( status : Int, data: Array<{content: User_status, type: Types}>) : Void {
        for(e in data) {
            this.list[new User(e.content.user_id)] = e.content;
        }
        on_response(data);
    }

    haxe.Timer.delay(function() {
        this.update_list(user, time, on_response);
    }, time);
 }

}
