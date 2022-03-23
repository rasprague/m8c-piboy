#!/bin/bash

DIALOGCMD="dialog --stdout --title \"m8-headless tracker client for Piboy DMG\" --menu \"Choose an Audio Interface\" 20 80 20"
AUDIOINCMD="dialog --stdout --title \"m8-headless tracker client for Piboy DMG\" --defaultno --yesno \"Enable Audio Input?\" 6 25"

CARDLIST=""
OPTIONS=""
I=0

OUTPUT=$(aplay -l | grep ^card)
while read line; do
    CARDLIST="$CARDLIST $I \"$line\""
    ((I=I+1))
done <<< "$OUTPUT"

/opt/retropie/admin/joy2key/joy2key start
SELECTION=$(eval $DIALOGCMD $CARDLIST)
EXITSTATUS=$?
if [ $EXITSTATUS = 0 ]; then
    echo "Selected Card $SELECTION"
    eval $AUDIOINCMD
    case $? in
	0) OPTIONS+=" --enable-input" ;;
	1) ;;
	2) echo "Cancelled." ; EXITSTATUS=1 ;;
    esac
else
    echo "Cancelled."
fi
/opt/retropie/admin/joy2key/joy2key stop

if [ $EXITSTATUS = 0 ]; then
    pushd /home/pi/code/m8c-piboy
    echo ./m8c.sh --interface $SELECTION $OPTIONS
    ./m8c.sh --interface $SELECTION $OPTIONS
    popd
fi
