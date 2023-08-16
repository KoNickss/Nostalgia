nostalgia: Main.vala Window.vala HeaderBar.vala Nostalgia.vala
	valac --pkg libnotify --pkg gtk+-3.0 Main.vala Window.vala HeaderBar.vala Nostalgia.vala -o nostalgia

install: nostalgia nostalgia-launcher.desktop
	cp ./nostalgia /usr/bin/
	cp ./nostalgia-launcher.desktop /usr/share/applications/

uninstall: 
	rm /usr/bin/nostalgia
	rm /usr/share/applications/nostalgia-launcher.desktop

clean: nostalgia
	rm nostalgia
