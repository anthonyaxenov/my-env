#!/bin/bash
#########################################################################
#                                                                       #
# Set display resolution                                                #
#                                                                       #
# Author: Anthony Axenov (Антон Аксенов)                                #
# Version: 1.0                                                          #
# License: WTFPL                                                        #
#                                                                       #
#########################################################################
#                                                                       #
# Using this script you can change your display resolution              #
# to any one you need. Just adjust some vars below and run script       #
# (chmod +x needed).                                                    #
#                                                                       #
#########################################################################

# https://gist.github.com/anthonyaxenov/c16e1181d4b8a8644c57ec8a1f6cf21c

# Set display name to work with. You can get it via 'xrandr --listactivemonitors'
display="HDMI-2"
# Set width of this display in px
width=1600
# Set height of this display in px
height=900

# Sometimes cvt and gtf generates different modelines.
# You can play around and look which of them gives best result:
modeline=$(cvt ${width} ${height} | grep "Modeline")
# modeline=$(gtf ${width} ${height} 60 | grep "Modeline")

# Some important data needed to xrandr:
modename="${width}x${height}_my"
params=$(echo "$modeline" | sed "s|^\s*Modeline\s*\"[0-9x_.]*\"\s*||")

echo "Set resolution ${width}x${height} on display $display:"
echo "$modename $params"

# Simple logic:
# 1. Switch display to safe mode which always exists (I believe) to avoid errors
xrandr --output $display --mode 640x480
# 2. If display aready have our mode -- we must delete it to avoid errors
if $(xrandr | grep -q "$modename"); then
    # 2.1. Detach mode from display
    xrandr --delmode $display $modename
    # 2.2. Remove mode itself
    xrandr --rmmode $modename
fi
# 3. Create new mode with freshly generated parameters
xrandr --newmode $modename $params
# 4. Attach mode to our display
xrandr --addmode $display $modename
# 5. Switch display to this mode immidiately
xrandr --output $display --mode $modename
