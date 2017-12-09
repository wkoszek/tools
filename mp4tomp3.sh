#!/bin/sh
# vim:set tw=1000:

echo $#

if [ $# -ne 1 ]; then
	echo "$0 <file>"
	exit;
fi

O=`echo "${1}" | sed 's/.mp4//g'`

ffmpeg -i "${1}" "${O}.mp3"
