#!/bin/sh

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
