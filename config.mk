# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

CPPFLAGS = 
CFLAGS   = -std=c99 -pedantic -Wall -O2 $(CPPFLAGS)
LDFLAGS  = -s

# compiler and linker
CC = cc

LEX = flex
