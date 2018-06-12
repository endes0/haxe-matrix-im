//Under GNU AGPL v3, see LICENCE
package m.call;

import m.call.Invite;

typedef Answer = {
    var call_id: String;
    var answer: Offer;
    var version: Int;
}