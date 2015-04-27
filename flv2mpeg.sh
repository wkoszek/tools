#!/bin/sh

for A in "$@"; do
	echo "# ${A} -- processing (${A}.mpeg -- where the output goes)"
	echo "mencoder -oac mp3lame -ovc copy -o" "${A}.mpeg" "${A}"
done
