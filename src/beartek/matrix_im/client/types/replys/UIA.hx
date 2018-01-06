//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.replys;

import com.akifox.asynchttp.HttpRequest;
import beartek.matrix_im.client.auths.Auth;
import beartek.matrix_im.client.auths.M_login_password;
import beartek.matrix_im.client.auths.M_login_token;
import beartek.matrix_im.client.auths.M_login_oauth2;
import beartek.matrix_im.client.auths.M_login_email_identity;
import beartek.matrix_im.client.auths.M_login_dummy;
import beartek.matrix_im.client.auths.Unknow_auth;
import beartek.matrix_im.client.types.enums.Auths;
import beartek.matrix_im.client.types.enums.Errors;

abstract UIA(UIA_body) {

  public inline function new( request : UIA_body ) {
    if( request.errcode != null ) {
      throw {errcode: request.errcode, error: request.error};
    } else {
      this = request;
    }
  }

  public inline function get() : UIA_body {
    return this;
  }

  public inline function get_flows() : Array<Array<Auths>> {
    var flows : Array<Array<Auths>> = [];
    for( flow in this.flows ) {
      flows.push(flow.stages);
    }
    return flows;
  }

  public static function fast_flow( uia : UIA_body ) : Int {
    var filtered = uia.flows.filter(function( v : {stages: Array<Auths>} ) : Bool {
      for( filter in UIA_config.evite ) {
        if( v.stages.indexOf(filter) != -1 ) {
          return false;
        }
      }
      return true;
    });

    if( filtered.length >= 1 ) {
      var result : {stages: Array<Auths>} = filtered[0];
      for( flow in filtered ) {
        if( flow.stages.length < result.stages.length ) {
          result = flow;
        }
      }
      return uia.flows.indexOf(result);
    } else {
      var result : {stages: Array<Auths>} = uia.flows[0];
      for( flow in uia.flows ) {
        if( flow.stages.length < result.stages.length ) {
          result = flow;
        }
      }
      return uia.flows.indexOf(result);
    }
    return 0;
  }

  public inline function get_flow( n : Int ) : Array<Auths> {
    return this.flows[n].stages;
  }

  public inline function select_flow( n : Int ) : Void {
    UIA_config.sessions.set(this.session,this.flows[n].stages);
  }

  public inline function start( on_stage : Auths -> Auth -> Void, on_response : Dynamic -> Void, request : HttpRequest, request_sender : HttpRequest -> (Int -> Dynamic -> Void) -> Void ) : Void {
    if( UIA_config.sessions.exists(this.session) ) {
      if( this.completed != null ) {
        for( stage in this.completed ) {
          UIA_config.sessions[this.session].remove(stage);
        }
      }

      var auth : Dynamic = UIA_config.sessions[this.session][0];
      var name : String = auth;
      var class_name : Class<Dynamic> = Type.resolveClass('beartek.matrix_im.client.auths.' + name.split('.').join('_'));
      var instance : Auth;
      if( class_name != null ) {
        instance = Type.createInstance(class_name, [this.session, Reflect.field(this.params, name)]);
      } else {
        instance = new Unknow_auth(this.session, name);
      }

      instance.on_response = function( status_code : Int, response : Dynamic ) : Void {
        if( Check_reply.is_UIA(response) ) {
          response.start(on_stage, on_response, request, request_sender);
        } else {
          on_response(response);
        }
      }
      instance.send_request = request_sender;
      instance.request = request;

      on_stage(UIA_config.sessions[this.session][0], instance);
    } else {
      throw 'No stage selected';
    }
  }

}

typedef UIA_body = {
  var flows : Array<{stages: Array<Auths>}>;
  var params : Dynamic;
  var session : String;
  @:optional var completed : Array<Auths>;
  @:optional var error : String;
  @:optional var errcode : Errors;
}
