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
echo "Selected card $SELECTION"
/opt/retropie/admin/joy2key/joy2key stop

if [ $EXITSTATUS = 0 ]; then
    echo ./m8c.sh --interface $SELECTION
    pushd /home/pi/code/m8c-piboy
    ./m8c.sh --interface $SELECTION
    popd
else
    echo "Cancelled."
fi
