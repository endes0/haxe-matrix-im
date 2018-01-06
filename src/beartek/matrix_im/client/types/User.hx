//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

abstract User(User_body) {

  public inline function new( v : String ) {
    var r = ~/@(.+):(.+)/g;
    if( r.match(v) ) {
      var user : User_body = {name: r.matched(1), server: r.matched(2)};
      this = user;
    } else {
      throw 'Invalid String';
    }

  }

  @:to public inline function toString() : String {
    return '@' + this.name + ':' + this.server;
  }

  public inline function get_user() : String {
    return this.name;
  }

  public inline function get_server() : String {
    return this.server;
  }
}

typedef User_body = {
  var name : String;
  var server : String;
}
