//Under GNU AGPL v3, see LICENCE
package m.call;

typedef Candidates = {
    var call_id: String;
    var candidates: Array<Candidate>;
    var version: Int;
}

typedef Candidate = {
    var sdpMid: String;
    var sdpMLineIndex: Int;
    var candidate: String;
}