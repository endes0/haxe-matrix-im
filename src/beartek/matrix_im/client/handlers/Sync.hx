//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.Event;
import beartek.matrix_im.client.types.enums.Presences;
import beartek.matrix_im.client.types.replys.Joined_room;
import beartek.matrix_im.client.types.replys.Invited_room;
import beartek.matrix_im.client.types.replys.Left_room;


class Sync extends Handler {
  public var batch : Map<String,String> = new Map();
  var presence_handlers : Array<Array<Event<Dynamic>> -> Void> = [];
  var account_data_handlers : Array<Array<Event<Dynamic>> -> Void> = [];
  var joined_handlers : Array<Map<String,Joined_room> -> Void> = [];
  var invite_handlers : Array<Map<String,Invited_room> -> Void> = [];
  var leave_handlers : Array<Map<String,Left_room> -> Void> = [];

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
  }

  public function sync( ?filter_id : String, ?filter : Dynamic, presence : Presences = Online, timeout : Int = 0, ?since : String, ?on_response : {next_bath : String, rooms : {join: Map<String,Joined_room>, invite: Map<String,Invited_room>, leave: Map<String,Left_room>}, presence : Array<Event<Dynamic>>, account_data : Array<Event<Dynamic>>} -> Void ) : Void {
    var req = Conection.make_request('GET', server + '/_matrix/client/r0/sync?timeout=' + timeout +
          (if(since != null || this.batch.exists(if(filter_id != null) filter_id else '000')) '&since=' + if(since != null) since else this.batch[if(filter_id != null) filter_id else '000'] else '') +
          '&set_presence=' + presence + (if(filter != null || filter_id != null) '&filter=' + if(filter != null) filter else filter_id else ''), null);
    req.timeout = timeout + 50;
    this.send_request(req, function( status : Int, data : Dynamic ) : Void {
      this.batch[if(filter_id != null) filter_id else '000'] = data.next_batch;
      var result = this.on_sync(data);
      if( on_response != null ) {
        on_response(result);
      } else {
        this.sync_manager(result);
      }
    });
  }

  public function sync_full_state( ?filter_id : String, ?filter : Dynamic, presence : Presences = Online, ?on_response : {next_bath : String, rooms : {join: Map<String,Joined_room>, invite: Map<String,Invited_room>, leave: Map<String,Left_room>}, presence : Array<Event<Dynamic>>, account_data : Array<Event<Dynamic>>} -> Void ) : Void {
    var req = Conection.make_request('GET', server + '/_matrix/client/r0/sync?filter=' + (if(filter) filter else filter_id)
          + '&set_presence=' + presence, null);
    this.send_request(req, function( status : Int, data : Dynamic ) : Void {
      var result = this.on_sync(data);
      if( on_response != null ) {
        on_response(result);
      } else {
        this.sync_manager(result);
      }
    });
  }

  public inline function add_presence_handler( handler : Array<Event<Dynamic>> -> Void ) : Void {
    presence_handlers.push(handler);
  }

  public inline function add_account_data_handler( handler : Array<Event<Dynamic>> -> Void ) : Void {
    account_data_handlers.push(handler);
  }

  public inline function add_room_handler( ?joined : Map<String,Joined_room> -> Void, ?invited : Map<String,Invited_room> -> Void, ?left: Map<String,Left_room> -> Void ) : Void {
    if( joined != null ) {
      joined_handlers.push(joined);
    }
    if( invited != null ) {
      invite_handlers.push(invited);
    }
    if( left != null ) {
      leave_handlers.push(left);
    }
  }

  private function sync_manager( data : {next_bath : String, rooms : {join: Map<String,Joined_room>, invite: Map<String,Invited_room>, leave: Map<String,Left_room>}, presence : Array<Event<Dynamic>>, account_data : Array<Event<Dynamic>>} ) : Void {
    for( func in joined_handlers ) {
      func(data.rooms.join);
    }
    for( func in invite_handlers ) {
      func(data.rooms.invite);
    }
    for( func in leave_handlers ) {
      func(data.rooms.leave);
    }

    for( func in presence_handlers ) {
      func(data.presence);
    }
    for( func in account_data_handlers ) {
      func(data.account_data);
    }
  }

  private function on_sync(data : {next_bath : String, rooms: {join: Dynamic, invite: Dynamic, leave: Dynamic}, presence: {events: Array<Event<Dynamic>>}, account_data: {events: Array<Event<Dynamic>>}}) : {next_bath : String, rooms : {join: Map<String,Joined_room>, invite: Map<String,Invited_room>, leave: Map<String,Left_room>}, presence : Array<Event<Dynamic>>, account_data : Array<Event<Dynamic>>} {
    var joined : Map<String,Joined_room> = Conection.to_object_map(data.rooms.join);
    var invited : Map<String,Invited_room> = Conection.to_object_map(data.rooms.invite);
    var leave : Map<String,Left_room> = Conection.to_object_map(data.rooms.leave);

    return {next_bath: data.next_bath, rooms: {join: joined, invite: invited, leave: leave}, presence: data.presence.events,account_data: data.account_data.events};
  }
}
