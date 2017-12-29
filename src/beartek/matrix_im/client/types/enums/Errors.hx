//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums;

@:enum abstract Errors(String) {
  var Forbidden = 'M_FORBIDDEN';
  var Unknown_token = 'M_UNKNOWN_TOKEN';
  var Unknown = 'M_UNKNOWN';
  var Not_found = 'M_NOT_FOUND';
  var Bad_json = 'M_BAD_JSON';
  var Not_json = 'M_NOT_JSON';
  var Missing_param = 'M_MISSING_PARAM';
  var Missing_token = 'M_MISSING_TOKEN';
  var Limit_exceeded = 'M_LIMIT_EXCEEDED';
  var User_in_use = 'M_USER_IN_USE';
  var Invalid_username = 'M_INVALID_USERNAME';
  var Room_in_use = 'M_ROOM_IN_USE';
  var Ivalid_room_state = 'M_INVALID_ROOM_STATE';
  var Bad_pagination = 'M_BAD_PAGINATION';
  var Threepid_in_use = 'M_THREEPID_IN_USE';
  var Threepid_not_found = 'M_THREEPID_NOT_FOUND';
  var Threepid_failed = 'M_THREEPID_AUTH_FAILED';
  var Server_not_trusted = 'M_SERVER_NOT_TRUSTED';
}
