#!/bin/bash

# requires naconnect installed at ~/code/naconnect
# $ sudo apt install libncurses-dev
# $ mkdir -p ~/code && cd ~/code
# $ git clone https://github.com/dctucker/naconnect.git && cd naconnect
# $ make

# button-to-keyboard mappings:
# * cursor keys for axis/dpad
# * c, d, TAB and q for buttons 'a', 'b', 'x' and 'y'
# * r, r for buttons 5,6 (shoulder buttons)
params=(kcub1 kcuf1 kcuu1 kcud1 0x63 0x64 0x09 0x71 0x72 0x72)

/opt/retropie/admin/joy2key/joy2key start "${params[@]}"
~/code/naconnect/naconnect
/opt/retropie/admin/joy2key/joy2key stop
