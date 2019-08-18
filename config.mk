# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

CPPFLAGS = 
CFLAGS   = -std=c99 -pedantic -Wall -O2 $(CPPFLAGS)
LDFLAGS  = -s

# if you use another lex change this
LIBS = -lfl

# compiler and linker
CC = c99

LEX = flex
