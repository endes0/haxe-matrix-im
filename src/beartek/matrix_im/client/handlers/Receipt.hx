//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.Event;
import beartek.matrix_im.client.types.User;
import beartek.matrix_im.client.types.Room;
import m.Receipt;

class Receipt extends Handler {

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
  }

  public function send_read(room: Room, event: String, ?on_response: Void -> Void) : Void {
    this.send_request(Conection.make_request(HttpMethod.POST, server + '/_matrix/client/r0/rooms/' + room + '/receipt/m.read/' + event, null), function ( status : Int, data: Dynamic ) : Void {
      on_response();
  }

  public function get_receipt_event(event: Event<Dynamic>): Event<Receipt_event> {
      var first: Map<String, Dynamic> = Conection.to_object_map(event.content);
      for (ev in first.keys()) {
          var data: Map<String, {ts: Int}> = Conection.to_object_map(Reflect.field(first[ev], 'm.read'));
          first[ev] = {
              user: new User(data.keys().next()),
              ts: data[data.keys().next()].ts
          }
      }

      event.content = first;
      return event;
  }
}
