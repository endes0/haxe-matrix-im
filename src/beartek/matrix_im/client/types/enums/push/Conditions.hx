//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums.push;

@:enum abstract Push_condition(String) {
  var Event_match = 'event_match';
  var Contains_display_name = 'contains_display_name';
  var Room_member_count = 'room_member_count';


}
