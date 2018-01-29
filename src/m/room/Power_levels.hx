//Under GNU AGPL v3, see LICENCE
package m.room;

typedef Power_levels = {
  @:optional var ban : Int;
  @:optional var events : Dynamic;
  @:optional var events_default : Int;
  @:optional var invite : Int;
  @:optional var kick : Int;
  @:optional var redact : Int;
  @:optional var state_default : Int;
  @:optional var users : Dynamic;
  @:optional var users_default : Int;
};
