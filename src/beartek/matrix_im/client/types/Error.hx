//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

typedef Error = {
  var errcode : Errors;
  var error : String;
  @:optional var retry_after_ms : String;
}
