PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

CPPFLAGS =
CFLAGS   = -std=gnu99 -pedantic -Wall -I$(SRCPREFIX) -O2 $(CPPFLAGS)
LDFLAGS  = $(CFLAGS) -s

CC = gcc
LEX = lex
