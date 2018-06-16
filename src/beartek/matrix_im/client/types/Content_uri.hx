//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types;

abstract Content_uri(Content_body) {

    public inline function new( v : String ) {
    var r = ~/mxc:\/\/(.+)\/(.+)/g;
    if( r.match(v) ) {
      var room : Content_body = {id: r.matched(2), server: r.matched(1)};
      this = room;
    } else {
      throw 'Invalid media URI';
    }

  }

  @:to public inline function toString() : String {
    return 'mxc://' + this.server + '/' + this.id;
  }

  public inline function get_media_id() : String {
    return this.id;
  }

  public inline function get_server() : String {
    return this.server;
  }

  public function equal( u : Content_uri ) : Bool {
    if( this.id == u.get_media_id() && this.server == u.get_server() ) {
      return true;
    } else {
      return false;
    }
  }
}

typedef Content_body = {
  var id : String;
  var server : String;
}