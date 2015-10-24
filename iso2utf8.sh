#!/bin/sh
for F in $*; do
	cp ${F} ${F}.bak
	iconv -f iso-8859-2 -t utf-8 < $F > ${F}_
	mv ${F}_ ${F}
done
