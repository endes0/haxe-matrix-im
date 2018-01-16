//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

typedef Filter = {
  var limit : Int;
  @:optional var not_senders : Array<String>;
  @:optional var not_types : Array<String>;
  @:optional var senders : Array<String>;
  @:optional var types : Array<String>;
};
