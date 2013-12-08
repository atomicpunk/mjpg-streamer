#!/bin/sh
#
# Copyright 2012 Todd Brandt <tebrandt@frontier.com>
#
# This program is free software; you may redistribute it and/or modify it
# under the same terms as Perl itself.
#    utility to set up development windows quickly
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

URL="http://192.168.1.6:8090/?action=stream"
OUTPATH="$HOME/Videos"
PIDFILE="$HOME/Videos/vlcrecord.pid"

printHelp() {
	echo ""
	echo "VLCRecord - records video from the OpenROV stream"
	echo "USAGE: vlcrecord start/stop"
	echo ""
	exit
}

recordingInProgress() {
	if [ ! -e $PIDFILE ]; then
		return 0
	fi
	PID=`cat $PIDFILE`
	PROCESS=`ps --pid $PID --no-headers | awk '{print $4}'`
	if [ "$PROCESS" = "vlc" ]; then
		return $PID
	fi
	return 0
}

on_start() {
	recordingInProgress
	PID=$?
	if [ $PID -gt 0 ]; then
		FILE=`ps --pid $PID -o args --no-headers | sed "s/.*dst=//;s/}.*//"`
		echo "Already Recording $PID: $FILE"
		return
	fi
	OUTFILE=`date "+openrov-%m%d%y-%H%M%S.mp4"`
	cvlc -vvv $URL --no-audio :sout=#transcode{}:file{dst=$OUTPATH/$OUTFILE} :sout-keep > /dev/null 2>&1 &
	PID=$!
	echo "New Recording $PID: $OUTPATH/$OUTFILE"
	echo $PID > $PIDFILE
}

on_stop() {
	recordingInProgress
	PID=$?
	if [ $PID -gt 0 ]; then
		FILE=`ps --pid $PID -o args --no-headers | sed "s/.*dst=//;s/}.*//"`
		echo "Stopping $PID: $FILE"
		kill -s QUIT $PID
		PSINFO=`ps --pid $PID --no-headers`
		while [ -n "$PSINFO" ] ; do
			echo -n "."
			sleep 1
			PSINFO=`ps --pid $PID --no-headers`
		done
		echo ""
		rm -f $PIDFILE
	else
		echo "No Recording"
	fi
}

if [ $# -lt 1 -o $# -gt 1 ]; then
	printHelp
fi

if [ $1 = "start" ]; then
	on_start
elif [ $1 = "stop" ]; then
	on_stop
else
	echo "ERROR: Invalid argument - $1"
	printHelp
fi
