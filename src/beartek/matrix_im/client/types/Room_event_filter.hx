//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

typedef Room_event_filter = {
  var limit : Int;
  @:optional var not_senders : Array<String>;
  @:optional var not_types : Array<String>;
  @:optional var senders : Array<String>;
  @:optional var types : Array<String>;
  @:optional var not_rooms : Array<String>;
  @:optional var rooms : Array<String>;
  var contains_url : Bool;
};
