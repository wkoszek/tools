#!/bin/sh

mount | grep BACKUP3G >> /dev/null
if [ $? -ne 0 ]; then
	echo "External disk not mounted"
	exit
fi

if [ $# -lt 1 ]; then
	echo "usage: video_move.sh <files>"
	exit
fi

mv -i $* /Volumes/BACKUP3G/COPIED_NEW_BACKUP/home/wkoszek/video/podcast/
