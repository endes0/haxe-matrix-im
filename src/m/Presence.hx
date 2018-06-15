package m;

import beartek.matrix_im.client.types.enums.Presences;

typedef Presence = {
    var avatar_url: String;
    var displayname: String;
    var last_active_ago: Int;
    var presence: Presences;
    var curently_active: Bool;
    var user_id: String;
}