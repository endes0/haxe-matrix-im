//Under GNU AGPL v3, see LICENCE
package beartek.matrix_im.client;

class Test_unit {

  static function main() {
		var run = new mohxa.Run([
        new Test_client(if(Sys.args()[0] == null) 'https://matrix.org:8448' else Sys.args()[0])
      ]);

		trace('completed ${run.total} tests, ${run.failed} failures (${run.time}ms)');
  }

}
