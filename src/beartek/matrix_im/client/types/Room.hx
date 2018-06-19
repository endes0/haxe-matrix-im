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
    return '!' + this.name + ':' + this.server;
  }

  public inline function get_name(?name_event: Event<m.room.Name>, ?canocial_alias: Event<m.room.Canonical_alias>, members: Map<String,{id: User, avatar_url: String}>) : String {
    if(name_event != null){
      return name_event.content.name;
    } else if(canocial_alias != null) {
      return canocial_alias.content.alias;
    } else {
      if(members != null) {
        var name1: String = '';
        var name2: String = '';
        var more = false;
        for(m in members.keys()) {
          if(name1 == null) {
            name1 = m;
          } else if(name1 == null) {
            name2 = m;
          } else {
            more = true;
            break;
          }
        }

        if(name1 != null && name2 == null) {
          return name1;
        } else if(name1 != null && name2 != null && !more) {
          return name1 + ' And ' + name2;
        } else {
          return name1 + ', ' + name2 + ' And more';
        }
      } else {
        return null;
      }
    }
  }

  public inline function get_room() : String {
    return this.name;
  }

  public inline function get_server() : String {
    return this.server;
  }

  public function equal( u : Room ) : Bool {
    if( this.name == u.get_room() && this.server == u.get_server() ) {
      return true;
    } else {
      return false;
    }
  }
}

typedef Room_body = {
  var name : String;
  var server : String;
}
