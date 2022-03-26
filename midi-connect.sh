#!/bin/bash

# requires naconnect installed at ~/code/naconnect/naconnect
# $ sudo apt install libncurses-dev
# $ mkdir -p ~/code && cd ~/code
# $ git clone https://github.com/dctucker/naconnect.git && cd naconnect
# $ make

# button-to-keyboard mappings:
# * cursor keys for axis/dpad
# * c (0x63),d (0x64),q (0x71),TAB (0x09) for buttons 'a','b','x','y'
# * r (0x72),r for buttons lt,rt (shoulder buttons)
#          l    r     u     d    a    b    x    y   lt   rt
params=(0x09 0x09 kcuu1 kcud1 0x63 0x64 0x71 0x09 0x72 0x72)

/opt/retropie/admin/joy2key/joy2key start "${params[@]}"
~/code/naconnect/naconnect
echo "Quitting . . ."
/opt/retropie/admin/joy2key/joy2key stop
echo "Done."
clear
