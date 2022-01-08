#!/bin/bash
echo
echo "==============================================="
echo "Installing wine..."
echo "==============================================="
echo

sudo dpkg --add-architecture i386
wget -qO- https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt install -y --autoremove winehq-stable
wine --version
