# haxe-matrix-im

Implementation of client-server matrix API in haxe using akifox-asynchttp. Because of it, tecnically only works on **CPP/NEKO/JAVA/FLASH** and not in **JAVASCRIPT**
because **JAVASCRIPT** only support *POST and Get* Methods. But, is only tested on neko Platform, if you test in other, let me know.

## Usage
Importing:
```haxe
import beartek.matrix_im.client.Conection;
```

Login in:
```haxe
var con = new Conection(server);
con.on_error = function( e : Dynamic ) : Void {
  throw 'Error: ' + e;
}

con.session.login_with_pass(user, password, device_name, function( respose : Dynamic ) : Void {
  trace(respose.access_token); //The access_token will be actumaticaly stored for future request until you logout.
});
```

Log out:
```haxe
con.session.logout(function() : Void {
  //Loged out
});
```

For more examples see the `Test_client` class in *test/beartek/matrix_im/client* and for more info see [Matrix Client-Server API docs](https://matrix.org/docs/spec/client_server/r0.3.0.html) (This library does not implement the API equal than described in the matrix docs).

## TODO
- Implement [modules](https://matrix.org/docs/spec/client_server/r0.3.0.html#modules).
- Add documetation to the class, types and functions.
- Make better README.

---
by [NetaLabTek](https://netalab.tk/)
