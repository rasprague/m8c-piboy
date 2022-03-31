# m8c-piboy

Changes (hacks) to the [m8c M8 tracker client](https://github.com/laamaa/m8c) for use on the PiBoy DMG. Tested on Raspberry Pi 3 B+ with RetroPie v4.7.1, reported working on Raspberry Pi 4. Also tested and working on a WaveShare Game HAT on Raspberry Pi 3 B+ with RetroPie v4.8.

Let's all enjoy the M8 software in a GameBoy style, while we wait for the official M8 hardware!

See it in action here https://www.youtube.com/watch?v=wgCUPZheRhA

### Notable changes
- [HACK force game controllers scan for PiBoy](https://github.com/rasprague/m8c-piboy/commit/f43110a650ecbf0918eba05c9e898f03cdaa4bdf)
- [add SDL controller line for PiBoy DMG to gamecontrollerdb.txt](https://github.com/rasprague/m8c-piboy/commit/7e59edb765d3f883a72e8de655d1eea0271f27e7)
- [add m8c startup shell scripts](https://github.com/rasprague/m8c-piboy/commit/f0b0909de3c5786992d8b540f5d09f841aeb7e33)
- [add two button combinations](https://github.com/rasprague/m8c-piboy/commit/0824b32c62525132de2850b9acddffaf9ea78fff)
  - select + opt + up = reset display
  - select + opt + down = quit program
- [add disable_cursor option to config](https://github.com/rasprague/m8c-piboy/commit/6844d93705db2d0330ded2f62bad6b60b798af90)
- [add audio input support via ENABLEINPUT variable in shell script](https://github.com/rasprague/m8c-piboy/commit/a1e340c59833d3ff3dabb633da3b03291e77d7e2)
- [add m8c-choose.sh, choose your audio interface from a list](https://github.com/rasprague/m8c-piboy/commit/fd04fd6c50caff03a6d7f25e08b1e628ce56b790)

# Thanks to
- [laamaa](https://github.com/laamaa) for the [cross-platform m8c client](https://github.com/laamaa/m8c)
- [DirtyWave](https://github.com/Dirtywave) for the excellent M8 Tracker and [m8 headless firmware](https://github.com/Dirtywave/M8HeadlessFirmware)
- u/rhinofinger for [this reddit post](https://www.reddit.com/r/RetroPie/comments/lurmu0/pico8_in_retropie_easy_uptodate_tutorial_with/) that clued me in on how to add entries into EmulationStation

# Requirements
- A working [m8 headless](https://github.com/Dirtywave/M8HeadlessFirmware) setup on a Teensy 4.1
- A PiBoy DMG with RetroPie installed and set up, see [the PiBoy DMG Getting Started guide](https://resources.experimentalpi.com/the-complete-piboy-dmg-getting-started-guide/)

# Installation

## building from source

These instructions are tested with Raspberry Pi 3 B+ and the official RetroPie distribution.

The instructions assume that you already have a working Retropie installation with an internet connection.

**Open Terminal or SSH into you Pi and run the following commands:**

### Install required packages

```
sudo apt update && sudo apt install -y git gcc make libsdl2-dev
```

### Build and install libserialport from source
Required since the libserialport-dev apt package is out of date

follow the README at https://github.com/sigrokproject/libserialport

then run
```
sudo ldconfig
```
to ensure the library is found when building m8c

### Download source code (All)

```
mkdir code && cd code
git clone https://github.com/rasprague/m8c-piboy.git
 ```

### Build the program

```
cd m8c-piboy
make
 ```

### Make shell scripts user executable
```
chmod u+x m8c*.sh
```

### Start m8c once to generate config files
```
/home/pi/code/m8c-piboy/m8c-nojack.sh
```
then Ctrl-C to quit

### Enable PiBoy DMG built-in controller support
A line to make the PiBoy built-in controller visible to SDL has been added to gamecontrollerdb.txt, we just need to point m8c to it.

```
cd ~/.local/share/m8c
rm gamecontrollerdb.txt
ln -s ~/code/m8c-piboy/gamecontrollerdb.txt .
```

### Optional: swap A and B buttons
in ~/.local/share/m8c/config.ini

change
```
gamepad_opt=1
gamepad_edit=0
```
to
```
gamepad_opt=0
gamepad_edit=1
```

### Optional: fix cursor movement
if your cursor movement is messed up, set these two entries in ~/.local/share/m8c/config.ini

```
gamepad_analog_axis_select=-1
gamepad_analog_axis_start=-1
```

### Optional: disable mouse cursor
in ~/.local/share/m8c/config.ini

under the ```[graphics]``` section, add ```disable_cursor=true```

### Install JACK for audio routing
See AUDIOGUIDE.md for the details

```
sudo apt install jackd2
sudo usermod -a -G audio pi
```

### Optional: allow JACKD to use realtime scheduling
```
sudo mv /etc/security/limits.d/audio.conf.disabled /etc/security/limits.d/audio.conf
```

then restart your system

### Try it out!
```
/home/pi/code/m8c-piboy/m8c.sh
```

# Adding m8c to EmulationStation

### Install m8c 'ROMs'
```
mkdir -p /home/pi/RetroPie/roms/m8 && cd /home/pi/RetroPie/roms/m8
ln -s /home/pi/code/m8c-piboy/*.sh .
```

### Add m8 system entry
- go to /home/pi/.emulationstation/
- append the contents of this repo's file es_systems.cfg.m8c.paste.txt to the bottom of es_systems.cfg (just before the ```</systemList>``` line) in that folder (/home/pi/.emulationstation/es_systems.cfg)

If you don't already have an es_systems.cfg file in /home/pi/.emulationstation/, first copy the es_systems.cfg file that's in /etc/emulationstation/ into /home/pi/.emulationstation/.

- restart EmulationStation

This adds "m8" to your EmulationStation game console selection menu.

# Using a different audio output device (e.g. external USB sounds card)

You have a couple of options

## Choose audio interface at startup
run m8c-choose.sh and choose you audio interface options from the dialogs

## Make a custom startup script
- find your audio device number with ```aplay -l```
```
pi@retropie:~ $ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: Headphones [bcm2835 Headphones], device 0: bcm2835 Headphones [bcm2835 Headphones]
  Subdevices: 8/8
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
  Subdevice #2: subdevice #2
  Subdevice #3: subdevice #3
  Subdevice #4: subdevice #4
  Subdevice #5: subdevice #5
  Subdevice #6: subdevice #6
  Subdevice #7: subdevice #7
card 1: CODEC [USB Audio CODEC], device 0: USB Audio [USB Audio]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 2: M8 [M8], device 0: USB Audio [USB Audio]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
```
here we'll use card 1 as an example

- in the m8 roms folder, make a copy of m8c-custom.sh.example, e.g.
```
cd ~/RetroPie/roms/m8
cp ~/code/m8c-piboy/m8c-custom.sh.example ./m8c-usbaudio.sh
```
- edit your new .sh file (e.g. m8c-usbaudio.sh), and at the top change e.g. ```HWAUDIODEVICE=0``` to ```HWAUDIODEVICE=1```
- Optioinal: enable audio input (if your audio interface supports it) by changning ```ENABLEINPUT=0``` to ```ENABLEINPUT=1```
- make your new .sh file (e.g. m8c-usbaudio.sh) executable with ```chmod u+x m8c-usbaudio.sh```
- restart EmulationStation

---
# orignal m8c README
# m8c

m8c is a client for Dirtywave M8 tracker's headless mode. The application should be cross-platform ready and can be built in Linux, Windows (with MSYS2/MINGW64) and Mac OS.

Please note that routing the headless M8 USB audio isn't in the scope of this program -- if this is needed, it can be achieved with tools like jackd, alsa\_in and alsa\_out for example. Check out the guide in file AUDIOGUIDE.md for some instructions on routing the audio.

Many thanks to:

Trash80 for the great M8 hardware and the original font (stealth57.ttf) that was converted to a bitmap for use in the progam.

driedfruit for a wonderful little routine to blit inline bitmap fonts, https://github.com/driedfruit/SDL_inprint/

marcinbor85 for the slip handling routine, https://github.com/marcinbor85/slip

turbolent for the great Golang-based g0m8 application, which I used as reference on how the M8 serial protocol works.

Disclaimer: I'm not a coder and hardly understand C, use at your own risk :)

-------

# Installation

## Windows / MacOS

There are prebuilt binaries available in the [releases section](https://github.com/laamaa/m8c/releases/) for Windows and recent versions of MacOS.

## Linux / MacOS (building from source)

These instructions are tested with Raspberry Pi 3 B+ and Raspberry Pi OS with desktop (March 4 2021 release), but should apply for other Debian/Ubuntu flavors as well. The begining on the build process on OSX is slightly different at the start, and then the same once packages are installed.

The instructions assume that you already have a working Linux desktop installation with an internet connection.

Open Terminal and run the following commands:

### Install required packages (Raspberry Pi, Linux)

```
sudo apt update && sudo apt install -y git gcc make libsdl2-dev libserialport-dev
```
### Install required packages (OSX)

This assumes you have [installed brew](https://docs.brew.sh/Installation)

```
brew update && brew install -y git gcc make sdl2 libserialport pkg-config
```
### Download source code (All)

```
mkdir code && cd code
git clone https://github.com/laamaa/m8c.git
 ```

### Build the program

```
cd m8c
make
 ```

### Start the program

Connect the M8 or Teensy (with headless firmware) to your computer and start the program. It should automatically detect your device.

```
./m8c
```

If the stars are aligned correctly, you should see the M8 screen.

-----------

## Keyboard mappings

Keys for controlling the progam:

* Up arrow = up
* Down arrow = down
* Left arrow = left
* Right arrow = right
* a / left shift = select
* s / space = start
* z / left alt = opt
* x / left ctrl = edit

Additional controls:
* Alt + enter = toggle full screen / windowed
* Alt + F4 = quit program
* Delete = opt+edit (deletes a row)
* Esc = toggle keyjazz on/off 
* r / select+start+opt+edit = reset display (if glitches appear on the screen, use this)

Keyjazz allows to enter notes with keyboard, oldschool tracker-style. The layout is two octaves, starting from keys Z and Q.
When keyjazz is active, regular a/s/z/x keys are disabled.

## Gamepads

The program uses SDL's game controller system, which should make it work automagically with most gamepads.

Enjoy making some nice music!

## Config

Keyboard and game controller bindings can be configured via `config.ini`.

If not found, the file will be created in one of these locations:
* Windows: `C:\Users\<username>\AppData\Roaming\m8c\config.ini`
* Linux: `/home/<username>/.local/share/m8c/config.ini`
* MacOS: `/Users/<username>/Library/Application Support/m8c/config.ini`

See the `config.ini.sample` file to see the available options.

-----------

## FAQ

* When starting the program, something like the following appears and the program does not start:
```
$ ./m8c
INFO: Looking for USB serial devices.
INFO: Found M8 in /dev/ttyACM1.
INFO: Opening port.
ERROR: Error: Failed: Permission denied
```

This is likely caused because the user running m8c does not have permission to use the serial port. The eaiest way to fix this is to add the current user to a group with permission to use the serial port.

On Linux systems, look at the permissions on the serial port shown on the line that says "Found M8 in":
```
$ ls -la /dev/ttyACM1
crw-rw---- 1 root dialout 166, 0 Jan  8 14:51 /dev/ttyACM0
```

This shows that the serial port is owned by the user 'root' and the grou 'dialout'. Both the user and the group have read/write permissions. To add a user to the group, run this command, replacing 'dialout' with the group shown on your own system:

    sudo adduser $USER dialout

You may need to log out and back in or even fully reboot the system for this change to take effect, but this will hopefully fix the problem. Please see [this issue for more details](https://github.com/laamaa/m8c/issues/20).

-----------

### Bonus content: quickly install m8c locally with nix

``` sh
nix-env -iA m8c-stable -f https://github.com/laamaa/m8c/archive/refs/heads/main.tar.gz
```
