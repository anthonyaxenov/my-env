#!/bin/bash

# https://obsproject.com/kb/virtual-camera-troubleshooting
# https://obsproject.com/forum/threads/how-to-start-virtual-camera-without-sudo-privileges.139783/
# https://blog.csdn.net/qq_43008667/article/details/128041455
# https://blog.jbrains.ca/permalink/using-obs-studio-as-a-virtual-cam-on-linux
# https://github.com/obsproject/obs-studio/issues/4808

# v4l2loopback-dkms

# obs_start()
# {
#     #This function is intended to prevent blank cameras in OBS upon OBS restart / exit
#     #1. load/refresh uvcvideo before starting obs
#     if lsmod | grep -q 'uvcvideo'; then
#         sudo rmmod uvcvideo
#     fi
#     sudo modprobe uvcvideo
#     #2. since no environment with a keyring to prompt for allowing virtual webcams prior is a must
#     sudo modprobe v4l2loopback video_nr=10 card_label='OBS Virtual Camera'
#     sleep 1
#     sh -c "$obs_cmd --startvirtualcam || sleep 3; sudo rmmod uvcvideo"
# }

installed () {
    command -v $1 > /dev/null
}

installed 'obs' && obs_cmd='obs'
installed 'obs-studio' && obs_cmd='obs-studio'

# obs executes this command when you start virtual camera
# sudo modprobe v4l2loopback exclusive_caps=1 card_label="OBS Virtual Camera"

# another version from one of links below
# sudo modprobe v4l2loopback video_nr=2 devices=1 card_label="OBS Virtual Camera"

sudo modprobe -r v4l2loopback || sudo rmmod v4l2loopback
if [[ $? == 0 ]]; then
    sudo modprobe v4l2loopback video_nr=2 devices=1 card_label="OBS Virtual Camera"
    if [[ $? == 0 ]]; then
        $obs_cmd --startvirtualcam & disown
    else
        echo "Cannot run modprobe. Ensure v4l2loopback-dkms is installed and try again"
        exit 1
    fi
else
    echo "Cannot remove v4l2loopback device"
    exit 2
fi
