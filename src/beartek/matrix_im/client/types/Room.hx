//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

abstract Room(Room_body) {

  public inline function new( v : String ) {
    var r = ~/!(.+):(.+)/g;
    if( r.match(v) ) {
      var room : Room_body = {name: r.matched(1), server: r.matched(2)};
      this = room;
    } else {
      throw 'Invalid String';
    }

  }

  @:to public inline function toString() : String {
    return '@' + this.name + ':' + this.server;
  }

  public inline function get_room() : String {
    return this.name;
  }

  public inline function get_server() : String {
    return this.server;
  }

  public function equal( u : User ) : Bool {
    if( this.name == u.get_user() && this.server == u.get_server() ) {
      return true;
    } else {
      return false;
    }
  }
}

typedef User_body = {
  var name : String;
  var server : String;
}
