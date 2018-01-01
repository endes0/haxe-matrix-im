//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

abstract Version(Ver) {
  public inline function new( v : String ) {
    this = {
      x: Std.parseInt(v.substr(1, 1)),
      y: Std.parseInt(v.substr(3, 1)),
      z: Std.parseInt(v.substr(5, 1))
    };
  }

  @:to public inline function toString() : String {
    return 'r' + this.x + '.' + this.y + '.' + this.z;
  }

  public inline function get_x() : Int {
    return this.x;
  }

  public inline function get_y() : Int {
    return this.y;
  }

  public inline function get_z() : Int {
    return this.z;
  }
}

typedef Ver = {
  var x : Int;
  var y : Int;
  var z : Int;
}
