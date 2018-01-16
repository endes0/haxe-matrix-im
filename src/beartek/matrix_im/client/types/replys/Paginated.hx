//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.replys;

typedef Paginated<T> = {
  var chunk : Array<T>;
  var start : Int;
  var end : Int;
};
