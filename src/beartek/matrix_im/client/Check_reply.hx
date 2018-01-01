//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client;


class Check_reply {
  static public function is_error( t : Dynamic ) : Bool {
    if( Reflect.field(t, 'errcode') == null ) {
      return false;
    } else {
      return true;
    }
  }

}
