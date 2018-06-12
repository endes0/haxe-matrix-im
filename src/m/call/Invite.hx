//Under GNU AGPL v3, see LICENCE
package m.call;

typedef Invite = {
    var call_id: String;
    var offer: Offer;
    var version: Int;
    var lifetime: Int;
}

typedef Offer = {
    var type: String;
    var sdp: String;
}