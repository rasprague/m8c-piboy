#!/bin/bash

# audio routing
export JACK_NO_AUDIO_RESERVATION=1
jackd -d alsa -d hw:M8 -r44100 -p512 &
sleep 1
alsa_out -j m8out -d hw:0 -r 44100 &
jack_connect system:capture_1 m8out:playback_1
jack_connect system:capture_2 m8out:playback_2

# start m8 client
pushd /home/pi/code/m8c-piboy
./m8c
popd

# clean up audio routing
killall -s SIGINT jackd alsa_out
