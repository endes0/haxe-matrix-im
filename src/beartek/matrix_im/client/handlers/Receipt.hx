//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.Event;
import beartek.matrix_im.client.types.User;
import m.Receipt;

class Receipt extends Handler {
  public var turn_servers : Array<String>;
  public var turn_username : String;
  public var turn_password : String;

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
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
