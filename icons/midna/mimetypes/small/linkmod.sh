#!/bin/sh
PATTERN1=`echo "$2"`
PATTERN2=`echo "$3"`
LINKNAME=`echo "$1"`
OLDTARGET=`readlink "$1"`
NEWTARGET=`echo "$OLDTARGET" \
| sed -e 's/'"$PATTERN1"'/'"$PATTERN2"'/'`
echo ln -nsf "$NEWTARGET" "$LINKNAME"
