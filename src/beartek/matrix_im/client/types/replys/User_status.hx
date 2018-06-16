//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.replys;

import beartek.matrix_im.client.types.enums.Presences;

typedef User_status = {
  var presence : Presences;
  var last_active_ago : Int;
  var status_msg : Null<String>;
  var currently_active : Bool;
  @:optional var user_id: String;
}