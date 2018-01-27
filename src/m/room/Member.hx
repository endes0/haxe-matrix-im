//Under GNU AGPL v3, see LICENCE
package m.room;

import beartek.matrix_im.client.types.enums.Memberships;

typedef Member = {
  var avatar_url : String;
  var displayname : Null<String>;
  var membership : Memberships;
  var is_direct : Bool;
  var third_party_invite : {
    display_name : String,
    signed : {mxid : String, signatures: Dynamic, token: String}
  };
};
