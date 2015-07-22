#!/bin/sh
# Copyright 2014 Wojciech A. Koszek <wojciech@koszek.com>
#
# apt-get install lynx gv wkhtmltopdf Xvfb
# Xvfb :99 &
# env DISPLAY=:99 ./alertbox.sh

NNGROUP='http://www.nngroup.com/articles/?page='

TMP=_.tmp
#rm -rf _.tmp
mkdir -p ${TMP}
cd ${TMP}
(
	ANUM=0
	seq 1 100 | while read NUM; do
		echo "# checking ${NUM}"
		#ls -la _.link.${NUM}
		if [ ! -f _.link.${NUM} ]; then
			echo "# > fetching ${NUM}"
			lynx --dump "${NNGROUP}${NUM}" > _.link.${NUM}
		fi
	done

	/bin/ls -1 _.link.* | sort -t . -k 3,3 -n | xargs cat |  awk	\
		'BEGIN { i = 0; }				\
		/http/ && /articles/ && ! /author/ && ! /page=/ && ! /articles\/$/ {	\
			files_o[i] = $2;			\
			files[$2] = 1;				\
			i++;					\
		}						\
		END {							\
			for (j = 0; j < i; j++) {			\
				if (files[files_o[j]] == 1) {		\
					files[files_o[j]] = 0;		\
					print files_o[j]		\
				}					\
			}						\
		}' 	\
	| while read LINK; do
		echo "# p ${ANUM} fetching ${LINK}"
		B=`basename $LINK`
		IMG=0_${B}.jpg
		PDF=0_${B}.pdf

		if [ ! -f $PDF ]; then
			echo "# will get PDF ${LINK}"
			wkhtmltopdf "$LINK" $PDF
			#wkhtmltopdf -p 127.0.0.1:8123 "$LINK" $PDF
		fi
		# Can't get wkhtmltoimage
		#if [ ! -f $IMG ]; then
		#	echo "# will get IMG ${LINK}"
		#	wkhtmltoimage -p 127.0.0.1:8123 "$LINK" $IMG
		#fi
		ANUM=`expr ${ANUM} + 1`
	done

	echo "# starting pdf generation"
	gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=alertbox.pdf `/bin/ls -1rt *.pdf | xargs`
	mv alertbox.pdf ..
)
