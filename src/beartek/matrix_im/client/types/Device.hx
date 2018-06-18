//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

typedef Device = {
  var device_id : String;
  @:optional var display_name : String;
  @:optional var last_seen_ip : String;
  @:optional var last_seen_ts : Int;
};