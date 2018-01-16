//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

typedef Room_filter = {
  @:optional var not_rooms : Array<String>;
  @:optional var rooms : Array<String>;
  var ephemeral : Array<Room_event_filter>;
  var include_leave : Bool;
  var state : Room_event_filter;
  var timeline : Room_event_filter;
  var account_data : Room_event_filter;
};
