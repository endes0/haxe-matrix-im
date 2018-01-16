//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.replys;

typedef Joined_room = {
  var state : {events: Array<Event<Dynamic>>};
  var timeline : Timeline;
  var ephemeral : {events: Array<Event<Dynamic>>};
  var account_data : {events: Array<Event<Dynamic>>};
  var unread_notifications : {highlight_count: Int, notification_count: Int};
}
