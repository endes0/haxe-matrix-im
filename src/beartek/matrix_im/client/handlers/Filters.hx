//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.types.User;
import beartek.matrix_im.client.types.Filter;
import beartek.matrix_im.client.types.Room_filter;

class Filters extends Handler {

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
  }

  public function add_filter( user : User, ?event_fields : Array<String>, presence : Filter, account_data : Filter, room : Room_filter, on_response : String -> Void ) : Void {
    var req : Dynamic = {
      event_format: 'client',
      presence: presence,
      account_data: account_data,
      room: room
    };
    if(event_fields != null) req.event_fields = event_fields;

    this.send_request(Conection.make_request('POST', server + '/_matrix/client/r0/user/' + user + '/filter', req), function( status : Int, data : {filter_id: String} ) : Void {
      on_response(data.filter_id);
    });
  }

  public function get_filter( user : User, id : String, on_response : Null<Array<String>> -> Filter -> Filter -> Room_filter -> Void ) : Void {
    this.send_request(Conection.make_request('GET', server + '/_matrix/client/r0/user/' + user + '/filter/' + id, null), function( status : Int, data : {event_fields:Null<Array<String>>, event_formats: String, presence: Filter, account_data: Filter, room: Room_filter} ) : Void {
      if( data.event_formats == 'federation' ) {
        throw 'The filter returned is for federation, not for client';
      } else {
        on_response(data.event_fields, data.presence, data.account_data, data.room);
      }
    });
  }
}
