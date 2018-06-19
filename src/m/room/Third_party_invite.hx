//Under GNU AGPL v3, see LICENCE
package m.room;

typedef Third_party_invite = {
    var display_name: String;
    var key_validity_url: String;
    var public_key: String;
    @:optional var public_keys: Array<PublicKeys>;
}

typedef PublicKeys = {
    @:optional var key_validity_url: String;
    var public_key: String;
}