//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.Version;
import beartek.matrix_im.client.types.User;
import beartek.matrix_im.client.types.Room;
import beartek.matrix_im.client.types.Event;
import beartek.matrix_im.client.types.enums.event.Types;
import beartek.matrix_im.client.types.enums.Visibilities;
import beartek.matrix_im.client.types.enums.Room_preset;
import beartek.matrix_im.client.types.enums.Directions;

class Rooms extends Handler {
  public var joined_rooms : Array<Room>;

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);

    this.list(function( rooms : Array<Room> ) : Void {
      this.joined_rooms = rooms;
    });
  }

  public inline function create( ?visibility : Visibilities, ?alias : String, ?name : String, ?topic : String, ?invite : Array<String>, ?invite_3pid : Array<{id_server : String, medium : String, address: String}>, ?creation_content: Dynamic, ?initial_state : Array<{type: String, state_key: String, content: String}>, ?preset : Room_preset, is_direct : Bool = false, on_response : Room -> Void ) : Void {
    var req : Dynamic = {is_direct: is_direct};
    if( visibility != null ) req.visibility = visibility;
    if( alias != null ) req.room_alias_name = alias;
    if( name != null ) req.name = name;
    if( topic != null ) req.topic = topic;
    if( invite != null ) req.invite = invite;
    if( invite_3pid != null ) req.invite_3pid = invite_3pid;
    if( creation_content != null ) req.creation_content = creation_content;
    if( initial_state != null ) req.initial_state = initial_state;
    if( preset != null ) req.preset = preset;

    this.send_request(Conection.make_request('POST', server + '/_matrix/client/r0/createRoom', req), function( status : Int, data : Dynamic ) : Void {
      on_response(new Room(data.room_id));
    });
  }

  public inline function invite( room : Room, user : User, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('POST', this.server + '/_matrix/client/r0/rooms/' + room + '/invite', {user_id: user.toString()}), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function join( room : Room, ?third_party_signed : {sender: String, mxid: String, token: String, signatures: Dynamic}, on_response : Room -> Void ) : Void {
    this.send_request(Conection.make_request('POST', this.server + '/_matrix/client/r0/rooms/' + room + '/join', if(third_party_signed != null) {third_party_signed: third_party_signed} else null), function( status : Int, data : Dynamic ) : Void {
      on_response(new Room(data.room_id));
    });
  }

  public inline function leave( room : Room, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('POST', this.server + '/_matrix/client/r0/rooms/' + room + '/leave', null), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function forget( room : Room, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('POST', this.server + '/_matrix/client/r0/rooms/' + room + '/forget', null), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function kick( room : Room, user : User, reason : String, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('POST', this.server + '/_matrix/client/r0/rooms/' + room + '/kick', {user_id: user.toString(), reason: reason}), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function ban( room : Room, user : User, reason : String, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('POST', this.server + '/_matrix/client/r0/rooms/' + room + '/ban', {user_id: user.toString(), reason: reason}), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function unban( room : Room, user : User, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('POST', this.server + '/_matrix/client/r0/rooms/' + room + '/ban', {user_id: user.toString()}), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function list( on_response : Array<Room> -> Void ) : Void {
    this.send_request(Conection.make_request('GET', this.server + '/_matrix/client/r0/joined_rooms', null), function( status : Int, data : {joined_rooms: Array<String>} ) : Void {
      on_response(data.joined_rooms.map(Room.new));
    });
  }

  public inline function list_public( ?server : String, limit: Int = 100, ?since : String, ?search : String, on_response : Array<{aliases: Array<String>, canonical_alias: String, name: String, num_joined_members: Int, room_id: String, topic: String, world_readable: Bool, guest_can_join: Bool, avatar_url: String}> -> String -> String -> Int -> Void ) : Void {
    var req : Dynamic = {limit: limit};
    if(server != null) req.server = server;
    if(since != null) req.since = since;
    if(search != null) req.filter.generic_search_term = search;

    this.send_request(Conection.make_request(if(search == null) 'GET' else 'POST', this.server + '/_matrix/client/r0/publicRooms', req), function( status : Int, data : Dynamic ) : Void {
      on_response(data.chunk, data.next_batch, data.prev_batch, data.total_room_count_estimate);
    });
  }

  public inline function add_alias( alias : String, room : Room, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('PUT', server + '/_matrix/client/r0/directory/room/%23' + alias + '%3A' + room.get_server(), {room_id : room.toString()}), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function remove_alias( alias : String, server : String, on_response : Void -> Void ) : Void {
    this.send_request(Conection.make_request('DELETE', this.server + '/_matrix/client/r0/directory/room/%23' + alias + '%3A' + server, null), function( status : Int, data : Dynamic ) : Void {
      on_response();
    });
  }

  public inline function get_room_from_alias( alias : String, server : String, on_response : Room -> Array<String> -> Void ) : Void {
    this.send_request(Conection.make_request('GET', this.server + '/_matrix/client/r0/directory/room/%23' + alias + '%3A' + server, null), function( status : Int, data : Dynamic ) : Void {
      on_response(new Room(data.room_id), data.servers);
    });
  }

  public inline function get_state_event_content( room : Room, type : Types, ?key : String, on_response : Dynamic -> Void ) : Void {
    this.get_room_events_content('/_matrix/client/r0/rooms/' + room + '/state/' + type + '/' + if(key != null) key else '', on_response);
  }

  public inline function get_state_events( room : Room, on_response : Array<Event<Dynamic>> -> Void ) : Void {
    this.get_room_events('/_matrix/client/r0/rooms/' + room + '/state', on_response);
  }

  public inline function get_members( room : Room, on_response : Array<Event<m.room.Member>> -> Void ) : Void {
    this.send_request(Conection.make_request('GET', server + '/_matrix/client/r0/rooms/' + room + '/members', null), function( status : Int, data : Dynamic ) : Void {
      on_response(data.chunk);
    });
  }

  public inline function get_joined_members( room : Room, on_response : Map<String,{display_name: String, avatar_url: String}> -> Void ) : Void {
    this.send_request(Conection.make_request('GET', server + '/_matrix/client/r0/rooms/' + room + '/joined_members', null), function( status : Int, data : Dynamic ) : Void {
      on_response(Conection.to_object_map(data.joined));
    });
  }

  public inline function get_messages( room : Room, from : String, ?to : String, dir : Directions, limit : Int = 10, ?filter : Dynamic, on_response : Array<Event<Dynamic>> -> Void ) : Void {
    this.send_request(Conection.make_request('GET', server + '/_matrix/client/r0/rooms/' + room + '/messages', {from: from, to: to, dir: dir, limit: limit, filter: filter}), function( status : Int, data : Dynamic ) : Void {
      on_response(data.chunk);
    });
  }

  public inline function send_state_event( room : Room, type : Types, ?key : String, content : Dynamic, on_response : String -> Void ) : Void {
    this.send_request(Conection.make_request('PUT', server + '/_matrix/client/r0/rooms/' + room + '/state/' + type + '/' + if(key != null) key else '', content), function( status : Int, data : Dynamic ) : Void {
      on_response(data.event_id);
    });
  }

  public inline function send_event( room : Room, type : Types, ?txnid : String, content : Dynamic, on_response : String -> Void ) : Void {
    if( txnid == null ) {
      txnid = Std.string(Std.random(100000));
    }

    this.send_request(Conection.make_request('PUT', server + '/_matrix/client/r0/rooms/' + room + '/state/' + type + '/' + txnid, content), function( status : Int, data : Dynamic ) : Void {
      on_response(data.event_id);
    });
  }

  public inline function redact_event( room : Room, event_id : String, ?txnid : String, reason : String, on_response : String -> Void ) : Void {
    if( txnid == null ) {
      txnid = Std.string(Std.random(100000));
    }
    this.send_request(Conection.make_request('PUT', server + '/_matrix/client/r0/rooms/' + room + '/redact/' + event_id + '/' + txnid, {reason: reason}), function( status : Int, data : Dynamic ) : Void {
      on_response(data.event_id);
    });
  }

  private function get_room_events( url : String, on_response : Array<Event<Dynamic>> -> Void ) : Void {
    this.send_request(Conection.make_request('GET', server + url, null), function( status : Int, data : Dynamic ) : Void {
      on_response(data);
    });
  }

  private function get_room_events_content( url : String, on_response : Dynamic -> Void ) : Void {
    this.send_request(Conection.make_request('GET', server + url, null), function( status : Int, data : Dynamic ) : Void {
      on_response(data);
    });
  }

}
