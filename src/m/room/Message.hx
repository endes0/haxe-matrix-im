//Under GNU AGPL v3, see LICENCE
package m.room;

import beartek.matrix_im.client.types.enums.Msg_types;

typedef Message = {
    var body : String;
    var msgtype : Msg_types;
    //TODO: URI Type??
    @:optional var url : String;
    @:optional var info : Info;
    @:optional var filename : String;
    @:optional var geo_uri : String;    
};

typedef Info = {
    @:optional var duration: Int;    
    @:optional var h: Int;
    @:optional var w: Int;
    //TODO: mimetype instead of string
    @:optional var mimetype: String;
    @:optional var size: Int;
    var thumbnail_url: String;
    var thumbnail_info: Thumbnail_info;
};

typedef Thumbnail_info = {
    var h: Int;
    var w: Int;
    //TODO: mimetype instead of string
    var mimetype: String;
    var size: Int;
};

