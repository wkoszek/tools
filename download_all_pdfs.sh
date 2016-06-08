#!/bin/sh

if [ $# -ne 2 ]; then
	echo "./download_all_pdfs.sh <dir> <link>"
	exit
fi

(
	mkdir -p $1
	cd $1
	lynx --dump $2 | grep -i pdf | awk '/http/ { print $2 }'  | wget -i -
)
