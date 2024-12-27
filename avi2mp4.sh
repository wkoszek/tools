#!/bin/sh
ffmpeg -i "$1" -c:a aac -b:a 128k -c:v libx264 -crf 23 "${1%%.avi}.mp4"
