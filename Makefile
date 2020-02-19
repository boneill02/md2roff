include config.mk

SRC = md2roff.l
OBJ = lex.yy.o

all: md2roff

md2roff: $(OBJ)
	$(CC) $(LDFLAGS) $(LIBS) -o $@ $(OBJ)

lex.yy.c: md2roff.l
	$(LEX) md2roff.l

lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -o $@ -c $^

clean:
	rm -f md2roff lex.yy.o lex.yy.c

install:
	cp md2roff $(PREFIX)/bin/md2roff
	cp md2roff.1 $(MANPREFIX)/man1/md2roff.1

uninstall:
	rm -f $(PREFIX)/bin/md2roff $(MANPREFIX)/man1/md2roff.1

test: md2roff
	sh test.sh

.PHONY: all clean
