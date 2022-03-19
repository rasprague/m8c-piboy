#!/bin/bash
HWOUTDEVICE=0
ENABLEINPUT=0
RATE=44100

# audio routing
export JACK_NO_AUDIO_RESERVATION=1
jackd -d alsa -d hw:M8 -r$RATE -p512 &
sleep 1

# setup output
alsa_out -j m8out -d hw:$HWOUTDEVICE -r $RATE &
sleep 1
jack_connect system:capture_1 m8out:playback_1
jack_connect system:capture_2 m8out:playback_2

# setup input
if [ $ENABLEINPUT -eq 1 ]; then
  alsa_in -j m8in -d hw:$HWOUTDEVICE -r $RATE &
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
