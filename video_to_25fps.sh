#!/bin/sh

F=$1
EXT=".`echo $1 | cut -d "." -f 2`"

ffmpeg -i $1 -r 25 ${F%%$EXT}_25fps${EXT}
