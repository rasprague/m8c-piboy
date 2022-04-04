#!/bin/bash

function joy2key_start {
    echo "Starting joy2key . . ."
    /opt/retropie/admin/joy2key/joy2key start
}

function joy2key_stop {
    echo "Stopping joy2key . . ."
    /opt/retropie/admin/joy2key/joy2key stop
}

trap joy2key_stop EXIT

CARDCMD="dialog --stdout --title \"m8-headless tracker client\" --menu \"Choose an Audio Interface\" 20 80 20"
RATECMD="dialog --stdout --title \"m8-headless tracker client\" --menu \"Choose a Sample Rate\" 10 30 20 0 44.1kHz 1 48kHz"
AUDIOINCMD="dialog --stdout --title \"m8-headless tracker client\" --defaultno --yesno \"Enable Audio Input?\" 6 25"

CARDLIST=""
OPTIONS=""
I=0

OUTPUT=$(aplay -l | grep ^card)
while read line; do
    CARDLIST="$CARDLIST $I \"$line\""
    ((I=I+1))
done <<< "$OUTPUT"

joy2key_start
CARD=$(eval $CARDCMD $CARDLIST)
[ $? != 0 ] && echo "Cancelled." && exit 1

RATE=$(eval $RATECMD)
[ $? != 0 ] && echo "Cancelled." && exit 1
if [ $RATE = 0 ]; then
    RATE=44100
elif [ $RATE = 1 ]; then
    RATE=48000
fi

eval $AUDIOINCMD
case $? in
    # yes
    0) OPTIONS+=" --enable-input" ;;
    # no
    1) ;;
    # [ESC]
    255) echo "Cancelled." ; exit 1 ;;
esac    
joy2key_stop

pushd /home/pi/code/m8c-piboy
echo ./m8c.sh --interface $CARD --rate $RATE $OPTIONS
./m8c.sh --interface $CARD --rate $RATE $OPTIONS
popd
