#!/bin/bash

DIALOGCMD="dialog --stdout --title \"M8 Tracker Client\" --menu \"Choose an Audio Interface\" 20 80 20"

CARDLIST=""
I=0

OUTPUT=$(aplay -l | grep ^card)
while read line; do
    #echo "CARD: " $I $line
    CARDLIST="$CARDLIST $I \"$line\""
    ((I=I+1))
done <<< "$OUTPUT"

/opt/retropie/admin/joy2key/joy2key start
SELECTION=$(eval $DIALOGCMD $CARDLIST)
EXITSTATUS=$?
if [ $EXITSTATUS = 0 ]; then
    echo "Selected Card $SELECTION"
else
    echo "Cancelled."
fi
/opt/retropie/admin/joy2key/joy2key stop

if [ $EXITSTATUS = 0 ]; then
    pushd /home/pi/code/m8c-piboy
    echo ./m8c.sh --interface $SELECTION
    ./m8c.sh --interface $SELECTION
    popd
fi
