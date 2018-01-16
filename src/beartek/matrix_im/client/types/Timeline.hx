//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

typedef Timeline = {
  var events : Array<Event<Dynamic>>;
  var limited : Bool;
  var prev_batch : String;
};
