#!/bin/bash

HWAUDIODEVICE=0
ENABLEINPUT=0
RATE=44100

usage()
{
    echo "Usage $0"
    echo "  options:"
    echo "    [ -i | --interface ] <I> - use audio interface I, defaults to 0"
    echo "      (see output from aplay -l command)"
    echo "    [ -r | --rate ] <R> - use R sample rate, defaults to 44100"
    echo "    [ -e | --enable-input = enable audio input, defaults is off"
    echo "    [ -h | --help ] show this helpful message"
}

OPTIONS=$(getopt -o i:r:eh --long interface:,rate:,enable-input,help -- "$@")
if [ $? -ne 0 ]; then
    usage
    exit 1
fi

eval set -- "$OPTIONS"

while true; do
    case "$1" in
	-i|--interface)
	    HWAUDIODEVICE=$2 ; shift 2 ;;
	-r|--rate)
	    RATE=$2 ; shift 2 ;;
	-e|--enable-input)
	    ENABLEINPUT=1 ; shift ;;
	-h|--help)
	    usage ; shift ; exit 0 ;;
	--)
	    shift ; break ;;
    esac
done

# audio routing
export JACK_NO_AUDIO_RESERVATION=1
jackd -d alsa -d hw:M8 -r$RATE -p512 &
sleep 1

# setup output
alsa_out -j m8out -d hw:$HWAUDIODEVICE -r $RATE &
sleep 1
jack_connect system:capture_1 m8out:playback_1
jack_connect system:capture_2 m8out:playback_2

# setup input
if [ $ENABLEINPUT -eq 1 ]; then
  alsa_in -j m8in -d hw:$HWAUDIODEVICE -r $RATE &
  sleep 1
  jack_connect m8in:capture_1 system:playback_1
  jack_connect m8in:capture_2 system:playback_2
fi

# start m8 client
pushd /home/pi/code/m8c-piboy
./m8c
popd

# clean up audio routing
killall -s SIGINT jackd alsa_out alsa_in
