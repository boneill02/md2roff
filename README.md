# md2roff

## Prerequisites

* A lex (I used flex, should be pretty portable though)
* GNU Make
* A C99 compiler (I used GCC)

## How??

* `make` it
* Pipe your Markdown input to `md2roff`

## How?? (Part 2) (for UNIX noobs using groff)

`./md2roff markdown.md | groff -ms -Tpdf >output.pdf`

## How?? (Part 2) (for UNIX chads using Heirloom Doctools)

`./md2roff markdown.md | troff -ms | dpost >output.ps`

## Why??

Pandoc can do the same I think but it is written in Haskell and I don't use
any Haskell programs so I tried to install Pandoc and it had too many
dependencies so I decided to write my own alternative.

## License

Copyright (C) 2019-2021 Ben O'Neill <ben@benoneill.xyz>. License: GNU
GPL Version 3 <https://gnu.org/licenses/gpl.html>. This is free
software: you are free to change and redistribute it. There is NO
WARRANTY, to the extent permitted by law.
