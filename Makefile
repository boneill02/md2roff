include config.mk

all: md2ms md2man md2roff

md2roff:
	$(CC) $(LDFLAGS) -o md2roff src/md2roff.c

md2ms: src/util.o
	$(LEX) -o src/$@_lex.yy.c src/$@.l
	$(CC) $(CFLAGS) -o src/$@_lex.yy.o -c src/$@_lex.yy.c
	$(CC) $(LDFLAGS) $(LIBS) -o $@ src/$@_lex.yy.o $^

md2man: src/util.o
	$(LEX) -o src/$@_lex.yy.c src/$@.l
	$(CC) $(CFLAGS) -o src/$@_lex.yy.o -c src/$@_lex.yy.c
	$(CC) $(LDFLAGS) $(LIBS) -o $@ src/$@_lex.yy.o $^

src/util.o: src/util.c
	$(CC) $(CFLAGS) -o $@ -c $^

clean:
	rm -f md2ms md2man md2roff src/*lex.yy.o src/*lex.yy.c src/util.o

install: md2ms md2man md2roff
	cp md2roff md2ms md2man $(PREFIX)/bin
	cp doc/md2ms.1 doc/md2man.1 doc/md2roff.1 $(DESTDIR)$(MANPREFIX)/man1
	chmod 755 $(DESTDIR)$(PREFIX)/bin/md2roff
	chmod 755 $(DESTDIR)$(PREFIX)/bin/md2ms
	chmod 755 $(DESTDIR)$(PREFIX)/bin/md2man
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/md2roff.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/md2ms.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/md2man.1

uninstall:
	rm -f $(PREFIX)/bin/md2roff $(PREFIX)/bin/md2ms $(PREFIX)/bin/md2man \
		  $(MANPREFIX)/man1/md2roff.1 $(MANPREFIX)/man1/md2ms.1 \
		  $(MANPREFIX)/man1/md2man.1

.PHONY: all clean md2ms md2man md2roff install uninstall