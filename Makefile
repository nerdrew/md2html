PREFIX=/usr/local
BINDIR= $(PREFIX)/bin
BINARIES=md2html.rb
APP=md2html.app

install:
	cp md2html.rb md2html.app/Contents/Resources
	install -d $(BINDIR)
	install -v $(BINARIES) $(BINDIR)
	cp -a $(APP) $(PREFIX)

.PHONY: install
