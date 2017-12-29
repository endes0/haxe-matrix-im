//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums;

@:enum abstract Msg_types(String) {
  var Text = 'm.text';
  var Emote = 'm.emote';
  var Notice = 'm.notice';
  var Image = 'm.image';
  var File = 'm.file';
  var Location = 'm.location';
  var Video = 'm.video';
  var Audio = 'm.audio';
}
