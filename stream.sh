#!/bin/sh

LOC=`pwd`
RES="1280x720"
FPS="15"
PORT="8090"

if [ $# -ge 1 -a "$1" = "--help" ]; then
	echo "USAGE: stream.sh <resolution> <framerate> <port>"
	exit
fi

if [ $# -ge 1 ]; then
	RES=$1
fi
if [ $# -ge 2 ]; then
	FPS=$1
fi
if [ $# -ge 3 ]; then
	PORT=$1
fi

./mjpg_streamer -i "$LOC/plugins/input_uvc/input_uvc.so -d /dev/video0 -r $RES -f $FPS" \
-o "$LOC/plugins/output_file/output_file.so" \
-o "$LOC/plugins/output_http/output_http.so -p $PORT"
