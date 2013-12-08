#!/bin/sh
#
# Copyright 2012 Todd Brandt <tebrandt@frontier.com>
#
# This program is free software; you may redistribute it and/or modify it
# under the GNU GPL license.
#
#    Script to initiate an mjpg video stream
#    Copyright (C) 2012 Todd Brandt <tebrandt@frontier.com>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

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
