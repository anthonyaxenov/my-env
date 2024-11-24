#!/bin/bash
# https://gist.github.com/anthonyaxenov/c16e1181d4b8a8644c57ec8a1f6cf21c
#########################################################################
#                                                                       #
# Set output resolution                                                 #
#                                                                       #
# Author: Anthony Axenov (Антон Аксенов)                                #
# Version: 1.0                                                          #
# License: WTFPLv2                                                      #
#                                                                       #
#########################################################################
#                                                                       #
# Using this script you can change your output resolution               #
# to any one you need. Just adjust some vars below and run script       #
# (chmod +x needed).                                                    #
#                                                                       #
#########################################################################

# Set output name to work with. You can get it via 'xrandr --listactivemonitors'
output="HDMI-3"
# Set width of this output in px
width=1920
# Set height of this output in px
height=1080
# Set refresh rate in Hz of this output in px
refresh=120

# Sometimes cvt and gtf generates different modelines.
# You can play around and look which of them gives best result:
modeline=$(cvt ${width} ${height} ${refresh} | grep "Modeline")
# modeline=$(gtf ${width} ${height} ${refresh} | grep "Modeline")

# Some important data needed to xrandr:
modename="${width}x${height}@${refresh}_my"
params=$(echo "$modeline" | sed "s|^\s*Modeline\s*\"[0-9x_.]*\"\s*||")

echo "Set resolution ${width}x${height}@${refresh} on output $output:"
echo "$modename $params"

# Simple logic:
# 1. Switch output to safe mode which always exists (I believe) to avoid errors
xrandr --output $output --mode 640x480 --verbose
# 2. If output aready have our mode -- we must delete it to avoid errors
if $(xrandr | grep -q "$modename"); then
    # 2.1. Detach mode from output
    xrandr --delmode $output $modename
    # 2.2. Remove mode itself
    xrandr --rmmode $modename
fi
# 3. Create new mode with freshly generated parameters
xrandr --newmode $modename $params --verbose
# 4. Attach mode to our output
xrandr --addmode $output $modename --verbose
# 5. Switch output to this mode immidiately
xrandr --output $output --mode $modename --refresh $refresh --verbose
