//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import beartek.matrix_im.client.types.Version;
import beartek.matrix_im.client.types.User;

class Server_adm extends Handler {
  public var versions : Array<Version>;

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);

    this.get_versions();
  }

  public function get_versions( ?on_response : Array<Version> -> Void ) : Void {
    this.send_request(Conection.make_request(HttpMethod.GET, server + '/_matrix/client/versions', null), function ( status : Int, data : {versions: Array<String>} ) : Void {
      var result : Array<Version> = data.versions.map(Version.new);
      this.versions = result;

      if( result.indexOf(new Version('r0.3.0')) == -1 ) {
        trace( 'Warning: Incompatible server version' );
      }

      if( on_response != null ) {
        on_response(result);
      }
    });
  }

  public function whois( user : User, on_response : Map<String,Array<Array<{ip: String, last_seen: Float, user_agent: String}>>> -> Void ) : Void {
    this.send_request(Conection.make_request(HttpMethod.GET, server + '/_matrix/client/r0/admin/whois/' + user.toString(), null), function( status : Int, data : {devices: Dynamic} ) : Void {
      if( status == 200 ) {
        var result : Map<String,Array<Array<{ip: String, last_seen: Float, user_agent: String}>>> = new Map();
        for( device in Reflect.fields(data.devices) ) {
          var data : {sessions: Array<{connections: Array<{ip: String, last_seen: Float, user_agent: String}>}>} = Reflect.field(data.devices, device);
          result[device] = [];
          for( session in data.sessions ) {

            result[device].push(session.connections);
          }
        }

        on_response(result);
      }

    });
  }

}
