PREFIX=/usr/local

install:
	install -d $(PREFIX)/bin
	install -v bin/md2html.rb $(PREFIX)/bin
	install -d $(PREFIX)/share/md2html
	install -v share/md2html/custom-css.html $(PREFIX)/share/md2html
	mkdir -p md2html.app/Contents/Resources/bin
	mkdir -p md2html.app/Contents/Resources/share/md2html
	cp bin/md2html.rb md2html.app/Contents/Resources/bin
	cp share/md2html/custom-css.html md2html.app/Contents/Resources/share/md2html
	cp -a md2html.app $(PREFIX)

.PHONY: install
