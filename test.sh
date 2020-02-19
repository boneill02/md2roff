#!/bin/sh

for f in tests/*.md; do
	./md2roff $f | groff -ms -Tps | zathura -
done
