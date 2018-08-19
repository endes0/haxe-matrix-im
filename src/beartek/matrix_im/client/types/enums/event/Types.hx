//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums.event;

@:enum abstract Types(String) {
  var Aliases = 'm.room.aliases';
  var Canonical_alias = 'm.room.canonical_alias';
  var Create = 'm.room.create';
  var Join_rules = 'm.room.join_rules';
  var Member = 'm.room.member';
  var Power_levels = 'm.room.power_levels';
  var Name = 'm.room.name';
  var Topic = 'm.room.topic';
  var Avatar = 'm.room.avatar';
  var Pinned_events = 'm.room.pinned_events';
  var Third_party_invite = 'm.room.third_party_invite';
  var Guest_access = 'm.room.guest_access';
  var History = 'm.room.history_visibility';

  var Redaction = 'm.room.redaction';
  var Message = 'm.room.message';
  var Feedback = 'm.room.message.feedback';

  var Presence = 'm.presence';
  var Typing = 'm.typing';
  var Receipt = 'm.receipt';
  var Tag = 'm.tag';
  var Direct = 'm.direct';

  var Invite = 'm.call.invite';
  var Candidates = 'm.call.candidates';
  var Answer = 'm.call.answer';
  var Hangup = 'm.call.hangup';

  var Widgets = 'im.vector.modular.widgets';
}
