public class MyApp.HeaderBar : Gtk.HeaderBar{
	public Gtk.Stack window_stack{ get; construct; }
	public HeaderBar(Gtk.Stack stack){
		Object(
			window_stack: stack
		);
	}
	construct{
		set_show_close_button(true);
		var stack_switcher = new Gtk.StackSwitcher();
		stack_switcher.stack = window_stack;
		set_custom_title(stack_switcher);
	}
}
