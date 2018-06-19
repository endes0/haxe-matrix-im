package beartek.matrix_im.client.types.enums;

@:enum abstract Guest(String) {
  var Joinable = 'can_join';
  var Forbidden = 'forbidden';
}