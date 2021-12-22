#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing wine"

sudo dpkg --add-architecture i386
wget -qO- https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
apti winehq-stable
installed "wine" && success "wine installed!"
