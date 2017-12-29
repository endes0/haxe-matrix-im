//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums;

@:enum abstract Join_rules(String) {
  var Invite = 'invite';
  var Public = 'public';
  var Private = 'private';
  var Knock = 'knock';
}
