//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client;

import beartek.matrix_im.client.types.enums.Auths;

class UIA_config {
  static public var sessions : Map<String,Array<Auths>> = new Map();
  static public var evite : Array<Auths> = [Recaptcha];

}
