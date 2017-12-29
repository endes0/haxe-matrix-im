//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client.types.enums;

@:enum abstract Auths(String) {
  var Password = 'm.login.password';
  var Recaptcha = 'm.login.recaptcha';
  var Oauth2 = 'm.login.oauth2';
  var Email = 'm.login.email.identify';
  var Token = 'm.login.token';
  var Dummy = 'm.login.dummy';
}
