#!/bin/sh
#
# Copyright 2012 Todd Brandt <tebrandt@frontier.com>
#
# This program is free software; you may redistribute it and/or modify it
# under the GNU GPL license.
#
#    Video record utility for mjpg-streamer
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

URL=""
LENGTH=300
OUTPATH="$HOME/Videos"
OUTFILE=`date "+%m%d%y-%H%M%S.mp4"`

printHelp() {
	echo ""
	echo "VLCRecord - records video from a network stream"
	echo "USAGE: vlcrecord <url> [len]"
	echo "Arguments"
	echo "    url: url for the network stream to record from"
	echo "    len: number of seconds to record for (default 300)"
	echo ""
	exit
}

if [ $# -lt 1 -o $# -gt 2 ]; then
	printHelp
fi

if [ $1 = "door" ]; then
	URL="http://localhost:8091/?action=stream"
	OUTFILE=$1-$OUTFILE
elif [ $1 = "front" ]; then
	URL="http://localhost:8090/?action=stream"
	OUTFILE=$1-$OUTFILE
elif [ $1 = "back" ]; then
	URL="http://slate.local:8090/?action=stream"
	OUTFILE=$1-$OUTFILE
else
	NAME=`echo $1 | sed "s/.*\/\///;s/\:.*//"`
	OUTFILE=$NAME-$OUTFILE
	URL=$1
fi

if [ $# -ge 2 ]; then
	CHECK=`echo $2 | sed "s/[0-9]//g"`
	if [ -n "$CHECK" ]; then
		echo "ERROR: What the hell is this? $2"
		printHelp
	fi
	LENGTH=`expr $2`
	if [ $LENGTH -lt 1 -o $LENGTH -gt 3600 ]; then
		echo "ERROR: Length has a minimum of 1 second, and a max of 1 hour"
		printHelp
	fi
fi

cvlc -vvv $URL --no-audio :sout=#transcode{vcodec=h264}:file{dst=$OUTPATH/$OUTFILE} :sout-keep > /dev/null 2>&1 &
PID=$!
echo "New Recording: $OUTPATH/$OUTFILE ..."
sleep 1
sleep $LENGTH
echo "Stopping: $OUTPATH/$OUTFILE"
kill -s QUIT $PID
