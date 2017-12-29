//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums.push;

@:enum abstract Rules(String) {
  var Master = '.m.rule.master';
  var Suppress_notices = '.m.rule.suppress_notices';
  var Invite_for_me = '.m.rule.invite_for_me';
  var Member_event = '.m.rule.member_event';
  var Contains_display_name = '.m.rule.contains_display_name';
  var Contains_user_name = '.m.rule.contains_user_name';
  var Call = '.m.rule.call';
  var Room_one_to_one = '.m.rule.room_one_to_one';
  var Message = '.m.rule.message';
  var Room_one_to_one = '.m.rule.room_one_to_one';



}
