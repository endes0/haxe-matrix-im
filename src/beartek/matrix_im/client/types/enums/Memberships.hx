//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums;

@:enum abstract Memberships(String) {
  var Invite = 'invite';
  var Join = 'join';
  var Knock = 'knock';
  var Leave = 'leave';
  var Ban = 'ban';
}
