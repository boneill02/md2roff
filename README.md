# md2roff

`md2roff` converts Markdown to roff source, using MS macros. This is useful for converting Markdown files to printable PDFs.

## Prerequisites

* A lex (tested with flex, should be pretty portable though)
* GNU Make
* A C compiler (I used GCC)

## How to use

Usage: `md2roff [-bnp] [-t title] [-a author] [-o outputfile] [inputfile]`

### Options

* `-b`: Disable page break between the title page and contents.
* `-n`: Disable display of the current date.
* `-p`: Convert to a PDF using groff.
* `-t title`: Set the document title.
* `-a author`: Set the document author.
* `-o outputfile`: Set the output file.

### Examples

```
# Convert to postscript
md2roff -t "My File" mymarkdown.md | groff -ms -Tps >myps.ps

# Convert to PDF
md2roff -p -t "My File" mymarkdown.md >mypdf.pdf
```

## License

Copyright (C) 2019-2025 Ben O'Neill <ben@oneill.sh>. License: MIT.
See LICENSE for more details.
