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

.PHONY: all clean
