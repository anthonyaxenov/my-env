#!/bin/bash

# https://obsproject.com/forum/threads/how-to-start-virtual-camera-without-sudo-privileges.139783/
sudo modprobe v4l2loopback video_nr=2 card_label="OBS Virtual Camera"
