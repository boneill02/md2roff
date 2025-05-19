# md2roff

`md2roff` converts Markdown to roff source (ms or man formats). This is useful
for converting Markdown files to printable PDFs or generating a manpage from
a Markdown file.

## Prerequisites

* A `lex`

## Building

```
make
sudo make install
```

## Usage

The wrapper program, `md2roff`, must take either `-ms` or `-man` as an argument.
Arguments for `md2ms` and `md2man` may be added as well. Input and output files
are `stdin` and `stdout` by default.

```
md2roff [-ms|-man] [args]
```

## Options

### md2ms

```
md2ms [-bnp] [-t title] [-a author] [-o outputfile] [inputfile]
```

* `-b`: Disable page break between the title page and contents.
* `-n`: Disable display of the current date.
* `-p`: Convert to a PDF using groff.
* `-t title`: Set the document title.
* `-a author`: Set the document author.
* `-o outputfile`: Set the output file.

### md2man

```
md2man [-t title] [-o outputfile] [inputfile]
```

* `-t title`: Add custom title header (`.TH`)
* `-o outputfile`: Set the output file.

### Examples

```
# Convert to postscript
md2roff -ms -t "My File" mymarkdown.md | groff -ms -Tps >myps.ps

# Convert to PDF
md2roff -ms -p -t "My File" mymarkdown.md >mypdf.pdf

# Convert to manpage
md2roff -man -t 'MYMANPAGE 1 "May 2025" "mymanpage" "User Commands"' mymarkdown.md >mymanpage.1
```

## License

Copyright (C) 2019-2025 Ben O'Neill <ben@oneill.sh>. License: MIT.
See LICENSE for more details.
