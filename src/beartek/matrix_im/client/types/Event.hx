//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

import beartek.matrix_im.client.types.enums.event.Types;

typedef Event<T> = {
  var event_id : String;
  var sender : String;
  var content : T;
  var type : Types;
  var origin_server_ts : Int;
  @:optional var state_key : String;
  @:optional var unsigned : Unsigned<T>;
  @:optional var prev_content : T;
  @:optional var invite_room_state : Array<{content: T, state_key: String, type: Types}>;
};

typedef Unsigned<T> = {
  var age : Int;
  @:optional var prev_content : T;
  @:optional var transaction_id : String;
  @:optional var redacted_because : Event<Dynamic>;
}
