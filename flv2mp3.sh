#!/bin/sh
# vim:set tw=1000:

# TODO: add signal handling.

echo $#

if [ $# -ne 1 ]; then
	echo "$0 <file>"
	exit;
fi

O=`echo "${1}" | sed 's/.flv//g'`
mencoder "${1}" -ovc frameno -oac mp3lame -lameopts preset=standard -o "${O}.avi" && \
mplayer "${O}.avi" -dumpaudio -dumpfile "${O}.mp3"
rm "${O}.avi"
