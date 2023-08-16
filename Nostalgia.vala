public class Nostalgia : Gtk.Application {
	public Nostalgia() {
		Object(
			application_id: "com.github.konickss.nostalgia",
			flags: ApplicationFlags.FLAGS_NONE
		);
	}
	protected override void activate (){
		var window = new MyApp.Window(this);
		add_window(window);
	}
}
