//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums;

@:enum abstract History_visibilities(String) {
  var Invited = 'invited';
  var Joined = 'joined';
  var Shared = 'shared';
  var World_readable = 'world_readable';
}
