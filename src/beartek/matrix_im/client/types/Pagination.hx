//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

import beartek.matrix_im.client.types.enums.Directions;

abstract Pagination(Pagination_body) {

  public inline function new( limit : Int, dir : Directions, ?from : Int, ?to : Int ) {
    this = {
      from: if(from != null) from else -1,
      to: if(to != null) to else -1,
      limit: limit,
      dir: dir
    };
  }

  public inline function get_from() : Null<Int> {
    if( this.from != -1 ) {
      return null;
    } else {
      return this.from;
    }
  }

  public inline function get_to() : Null<Int> {
    if( this.to != -1 ) {
      return null;
    } else {
      return this.to;
    }
  }

  public inline function get_limit() : Int {
    return this.limit;
  }

  @:to
  public inline function toString() : String {
    return '?from=' + (if(this.from == -1) 'START' else Std.string(this.from)) + '&limit=' + this.limit + '&dir=' + this.dir + '&to=' + (if(this.to == -1) 'END' else Std.string(this.to));
  }
}

typedef Pagination_body = {
  var from : Int;
  var to : Int;
  var limit : Int;
  var dir : Directions;
}
