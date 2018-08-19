//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.handlers;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpMethod;
import com.akifox.asynchttp.HttpResponse;
import beartek.matrix_im.client.types.Content_uri;
import beartek.matrix_im.client.types.enums.Thumb_method;
using StringTools;

class Content extends Handler {

  public function new( on_responses : Int -> Dynamic -> ?Bool -> Bool, send_request : HttpRequest -> (Int -> Dynamic -> Void) -> ?Bool -> Void, server : String ) {
    super(on_responses, send_request, server);
  }

  public function upload(filename: String, mimetype: String, content: Dynamic, ?on_response: Content_uri -> Void) : Void {
    var request = new HttpRequest({
      url: server + '/_matrix/media/r0/upload?filename=' + filename,
      method: HttpMethod.POST,
      contentType: mimetype,
      content: content
    });
    this.send_request(request, function ( status : Int, data: {content_uri: String} ) : Void {
      on_response(new Content_uri(data.content_uri));
    });
  }

  public function download(content_uri: Content_uri, ?on_response: String -> String -> haxe.io.Bytes -> Void) : Void {
    var request = new HttpRequest({
      url: server + '/_matrix/media/r0/download/' + content_uri.get_server() + '/' + content_uri.get_media_id(),
      method: HttpMethod.GET
    });

    #if debug
    trace( 'sending request: ' + request.content );
    #end
    request.callback = function( response : HttpResponse ) : Void {
      #if debug
      trace( 'callback called' );
      #end
      on_response(response.headers.get('Content-Type'), response.headers.get('Content-Disposition'), response.contentRaw);
    };
    request.async = false;
    request.send();
  }

  public function download_thumbnail(content_uri: Content_uri, width: Int, height: Int, thumb_method: Thumb_method, ?on_response: String -> haxe.io.Bytes -> Void) : Void {
    var request = new HttpRequest({
      url: server + '/_matrix/media/r0/thumbnail/' + content_uri.get_server() + '/' + content_uri.get_media_id() + '?width=' + width + '&height=' + height + '&method=' + thumb_method,
      method: HttpMethod.GET
    });

    #if debug
    trace( 'sending request: ' + request.content );
    #end
    request.callback = function( response : HttpResponse ) : Void {
      #if debug
      trace( 'callback called' );
      #end
      on_response(response.headers.get('Content-Type'), response.contentRaw);
    };
    request.async = false;
    request.send();
  }

  public function preview_url(url: String, time: Int, ?on_response: Map<String, String> -> Void) : Void {
    this.send_request(Conection.make_request(HttpMethod.GET, server + '/_matrix/media/r0/preview_url?url=' + url.urlEncode() + '&ts=' + time, null), function ( status : Int, data: Dynamic ) : Void {
      on_response(Conection.to_object_map(data));
    });
  }

}
