#!/bin/bash
# $Id$



LPR=$1
WARN=10
ERROR=15

QUEUE=`lpq -a | wc -l |  sed 's/^ *//' | sed 's/ *$//'`
QUEUE=$(($QUEUE-1))

INFO="Queue($QUEUE)"

if [ $QUEUE -gt $ERROR ]; then
      	echo "CRITICAL - $INFO"
	exit 2
fi

if [ $QUEUE -gt $ERROR ]; then
        echo "WARN - $INFO"
        exit 1
fi

echo "OK - $INFO"
exit 0
