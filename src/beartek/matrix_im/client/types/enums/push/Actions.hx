//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums.push;

@:enum abstract Actions(String) {
  var Notify = 'notify';
  var Dont_notify = 'dont_notify';
  var Coalesce = 'coalesce';
  var Set_tweak = 'set_tweak';
}
