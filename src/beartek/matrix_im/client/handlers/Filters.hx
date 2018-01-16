//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.User;
import beartek.matrix_im.client.types.Filter;
import beartek.matrix_im.client.types.Room_filter;

class Filters {
  var server : String;

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    this.on_responses = on_responses;
    this.send_request = send_request;
    this.server = server;
  }

  public function add_filter( user : User, ?event_fields : Array<String>, precence : Filter, account_data : Filter, room : Room_filter, on_response : String -> Void ) : Void {
    this.send_request(Conection.make_request('POST', server + '/_matrix/client/r0/user/' + user + '/filter', {
      event_fields: event_fields,
      event_formats: 'client',
      precence: precence,
      account_data: account_data,
      room: room
    }), function( status : Int, data : {filter_id: String} ) : Void {
      on_response(data.filter_id);
    });
  }

  public function get_filter( user : User, id : String, on_response : Null<Array<String>> -> Filter -> Filter -> Room_filter -> Void ) : Void {
    this.send_request(Conection.make_request('GET', server + '/_matrix/client/r0/user/' + user + '/filter/' + id, null), function( status : Int, data : {event_fields:Null<Array<String>>, event_formats: String, precence: Filter, account_data: Filter, room: Room_filter} ) : Void {
      if( data.event_formats == 'federation' ) {
        throw 'The filter returned is for federation, not for client';
      } else {
        on_response(data.event_fields, data.precence, data.account_data, data.room);
      }
    });
  }

  dynamic function send_request( request : HttpRequest, on_response : Int -> Dynamic -> Void, ignore_errors : Bool = false ) : Void {
    throw 'Handler created erroniusly';
  }

  dynamic function on_responses( status_code : Int, response : Dynamic, ignore_errors : Bool = false ) : Bool {
    return true;
  }

}
