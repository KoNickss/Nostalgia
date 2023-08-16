public class MyApp.Window : Gtk.ApplicationWindow{
	string laoutput;
	bool upol;
	public bool process_line (IOChannel channel, IOCondition condition, string stream_name, out string x, out bool y) {
	if (condition == IOCondition.HUP) {
		print ("%s: The fd has been closed.\n", stream_name);
		return false;
	}

	try {
		string line;
		channel.read_line (out line, null, null);
		print ("%s: %s", stream_name, line);
		x = line;
		y = true;
	} catch (IOChannelError e) {
		print ("%s: IOChannelError: %s\n", stream_name, e.message);
		return false;
	} catch (ConvertError e) {
		print ("%s: ConvertError: %s\n", stream_name, e.message);
		return false;
	}
	return true;
	}
	public Window(Nostalgia application){
		Object(
			application: application
		);
	}
	construct{
		bool ssnap=false;
		var actualstack = new Gtk.Stack();
		actualstack.expand = true;
		var createstack = new Gtk.Stack();
		createstack.expand = true;
		var memc = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		var memr = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		var cr1 = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		var progresscr = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		//memr.add(new Gtk.Label("Restore"));
		actualstack.add_titled(memc, "memc", "Create");
		actualstack.add_titled(memr, "memr", "Restore");
		createstack.add_titled(cr1, "cr1", "Backup Options");
		createstack.add_titled(progresscr, "progresscr", "Snapshot Progress" );
		actualstack.set_transition_type(Gtk.StackTransitionType.SLIDE_UP_DOWN);
		actualstack.set_transition_duration(750);
		createstack.set_transition_type(Gtk.StackTransitionType.SLIDE_UP_DOWN);
		createstack.set_transition_duration(750);
		//memc.set_column_homogeneous(true);
		//memc.set_row_homogeneous(true);
		
		
		//BACKUP MENU INTERFACE
		var label1 = new Gtk.Label("<span size='xx-large' weight='bold'>Back up all your files and memories,
For when you need them the most</span>");
		label1.set_use_markup(true);
		memc.pack_start(label1, true, true, 50);
		//memc.pack_start(new Gtk.Image.from_icon_name("liveusb-creator", Gtk.IconSize.DIALOG), false, false, 0);
		memc.pack_start(new Gtk.Label("Nostalgia makes incremental snapshots, that means:
✔ Only the first snapshot contains the full file system
✔ All snapshots after the first only document changes
✔ It takes up significantly less space compared to full system snapshots
✔ You can hold lots of backups on a drive"), true, false, 0);
		var button1 = new Gtk.Button.with_label("Create memory");
		var blue_color = new Gdk.RGBA();
		blue_color.parse("#0860F2");
		var green_color = new Gdk.RGBA();
		green_color.parse("#59C837");
		button1.override_background_color(Gtk.StateFlags.NORMAL, green_color);
		var gridfb = new Gtk.Grid();
		gridfb.attach(button1, 1, 1);
		button1.clicked.connect (() => {
			createstack.set_visible_child(cr1);
			print("Create Button Pressed \n");
			remove(actualstack);
			add(createstack);
			createstack.set_visible_child(cr1);
			var crtitlebar = new MyApp.HeaderBar(createstack);
			set_titlebar(crtitlebar);
			show_all();
		});
		gridfb.attach(new Gtk.Label(""), 2, 1);
		gridfb.attach(new Gtk.Label(""), 0, 1);
		gridfb.set_column_homogeneous(true);
		gridfb.set_row_homogeneous(true);
		//var img1 = new Gtk.Image.from_icon_name("liveusb-creator", Gtk.IconSize.DIALOG);
		//memc.pack_start(img1, false, false, 30);
		memc.pack_start(gridfb, true, true, 60);
		
		
		var label1r = new Gtk.Label("<span size='xx-large' weight='bold'>For when the worst happens,
I'm here to get you back online</span>");
		label1r.set_use_markup(true);
		memr.pack_start(label1r, true, true, 50);
		memr.pack_start(new Gtk.Label("You can use this option to restore your lost files
and configurations from any of your backups. Keep in mind
restoring your entire system using this tool may take a while,
so please be patient and let us get your system back and running"), true, false, 0);
		var button1r = new Gtk.Button.with_label("Restore Memory");
		button1r.override_background_color(Gtk.StateFlags.NORMAL, blue_color);
		var gridfbr = new Gtk.Grid();
		gridfbr.attach(button1r, 1, 1);
		gridfbr.attach(new Gtk.Label(""), 0, 1);
		gridfbr.attach(new Gtk.Label(""), 2, 1);
		gridfbr.set_column_homogeneous(true);
		gridfbr.set_row_homogeneous(true);
		memr.pack_start(gridfbr, true, true, 60);
		
		//CREATESTACK STUFF
		cr1.pack_start(new Gtk.Label(""), false, false, 100);
		var cr11 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		//cr11.expand = true;
		cr11.pack_start(new Gtk.Label(""), true, true, 40);
		var cr1label = new Gtk.Label("<span size='x-large' weight='bold'>Select your backup drive:</span>");
		cr1label.set_use_markup(true);
		cr11.pack_start(cr1label, true, true, 10);
		var crloc1 = new Gtk.FileChooserButton("Set location", Gtk.FileChooserAction.SELECT_FOLDER);
		cr11.pack_start(crloc1, true, true, 0);
		cr11.pack_start(new Gtk.Label(""), true, true, 10);
		cr1.pack_start(cr11, false, false, 0);
		cr1.pack_start(new Gtk.Label(""), false, false, 15);
		var cr12 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		var crbackbutton = new Gtk.Button.with_label("↩ Go back");
		crbackbutton.clicked.connect (() => {
			if (!ssnap){
				print("Menu Button Pressed \n");
				remove(createstack);
				add(actualstack);
				var hmtitlebar = new MyApp.HeaderBar(actualstack);
				set_titlebar(hmtitlebar);
				show_all();
				string x;
				//Process.spawn_command_line_sync("lsblk", out x);
				//print(x);
			}
		});
		cr12.pack_start(crbackbutton, false, false, 10);
		var packhome = new Gtk.Switch();
		packhome.set_state(true);
		var cr14 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		cr14.pack_start(new Gtk.Label(""), true, true, 10);
		var packhomela = new Gtk.Label("<span size='x-large' weight='bold'>Include home folder in backup:</span>");
		packhomela.set_use_markup(true);
		cr14.pack_start(packhomela, false, false, 10);
		cr14.pack_start(packhome, false, false, 10);
		cr14.pack_start(new Gtk.Label(""), true, true, 10);
		cr1.pack_start(cr14, false, false, 0);
		var finbutcr = new Gtk.Button.with_label("✔ Make snapshot");
		finbutcr.override_background_color(Gtk.StateFlags.NORMAL, green_color);
		cr12.pack_end(finbutcr, false, false, 10);
		finbutcr.clicked.connect (() => {
			if(!ssnap){
				print(crloc1.get_filename());
				string loc = crloc1.get_filename();
				print("\n");
				if (crloc1.get_filename() == null){
					var ibl = new Gtk.Dialog.with_buttons("Invaild backup location", this, Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT | Gtk.DialogFlags.USE_HEADER_BAR, null);
					var iblca = ibl.get_content_area();
					iblca.add(new Gtk.Label("

					"));
					iblca.add(new Gtk.Label("	Make sure the folder you picked is mounted and exists	"));
					iblca.add(new Gtk.Label("
					
					"));
					ibl.show_all();
					
				}else{
					ssnap=true;
					createstack.set_visible_child(progresscr);
					string isfile;
					Process.spawn_command_line_sync("file " + crloc1.get_filename() + "/nostalgia.file", out isfile);
					string isft = crloc1.get_filename() + "/nostalgia.file: empty ";
					print(isfile);
					print(isft);
					//The length will never be the same if the file is not found
					if(isfile.char_count() != isft.char_count()){
						print("\n root backup \n");
						string testx;
						Process.spawn_command_line_sync("bash command", out testx);
						progresscr.pack_start(new Gtk.Label(testx));
						//print(testx);
						progresscr.pack_start(new Gtk.Label("This seems to be your first nostalgia backup on this harddrive, so it will take a while"), false, false, 10);
						show_all();
					}
					string[] spawn_env1 = Environ.get();
					Pid rpid;
					int otcr;
					int dum;
					bool lop=true;
					//Process.spawn_async_with_pipes(loc, {"rsync", "-a", "~/debian", "~/test", "--no-i-r"}, spawn_env1, SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD, null, out rpid, out dum, out otcr, out dum);
					Process.spawn_async_with_pipes(loc, {"bash", "install"}, spawn_env1, SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD, null, out rpid, out dum, out otcr, out dum);
					IOChannel outputcr = new IOChannel.unix_new(otcr);
					outputcr.add_watch(IOCondition.IN | IOCondition.HUP, (channel, condition) => {
						return process_line(channel, condition, "stdout", out laoutput, out upol);
					});
					bool should_stop = false;
					var ol = new Gtk.Label(laoutput);
					ChildWatch.add(rpid, (pid, status) => {
						Process.close_pid(rpid);
						print("hihi");
						ssnap=false;
						createstack.set_visible_child(cr1);
						lop=false;
						Notify.init("Nostalgia");
						var notification = new Notify.Notification("Nostalgia", "Your snapshot is ready", "deja-dup");
						notification.set_timeout(0);
						notification.show();
						should_stop = true;
						progresscr.remove(ol);
					});
					progresscr.pack_start(ol, true, true, 10);
					show_all();
					Timeout.add(750, () => {
						ol.set_text(laoutput);
						show_all();
						return should_stop ? Source.REMOVE : Source.CONTINUE;
					});
				}
			}
		});
		cr1.pack_end(cr12, false, false, 10);
		
		add(actualstack);
		
		var headerbar = new MyApp.HeaderBar(actualstack);
		set_titlebar(headerbar);
		window_position = Gtk.WindowPosition.CENTER;
		window_position = Gtk.WindowPosition.CENTER;
		set_default_size(800, 600);
		set_resizable(false);
		show_all();
		print("Hey, thanks for choosing nostalgia! \n");
		print("If you're looking at the debug output most probably you're having some trouble with this program, so feel free to email me at konicksdev@gmail.com and I'll see if I can help \n");
	}
}
