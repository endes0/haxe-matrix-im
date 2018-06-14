//Under GNU AGPL v3, see LICENCE
package m;

import beartek.matrix_im.client.types.User;

typedef Receipt_event = {
    var events: Map<String, Read>;
}

typedef Read = {
    var user: User;
    var ts: Int;
}