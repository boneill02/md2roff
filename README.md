# md2roff

## Prerequisites

* A lex (tested with flex, should be pretty portable though)
* GNU Make
* A C compiler (I used GCC)

## How to use

* `make` it
* Pipe your Markdown input to `md2roff`, examples below:

```
# Using groff
./md2roff markdown.md | groff -ms -Tpdf >output.pdf`

# Using heirloom doctools or similar
`./md2roff markdown.md | troff -ms | dpost >output.ps`
```

## License

Copyright (C) 2019-2025 Ben O'Neill <ben@oneill.sh>. License: MIT.
See LICENSE for more details.
