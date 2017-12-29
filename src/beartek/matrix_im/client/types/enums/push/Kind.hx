//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums.push;

@:enum abstract Kind(String) {
  var Override = 'override';
  var Underride = 'underride';
  var Sender = 'sender';
  var Room = 'room';
  var Content = 'content';
}
