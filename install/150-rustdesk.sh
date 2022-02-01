#!/bin/bash
VER="1.1.8"
echo
echo "==============================================="
echo "Installing rustdesk v${VER}..."
echo "==============================================="
echo

# https://github.com/rustdesk/rustdesk

sudo apt install libxdo3
wget "http://github.com/rustdesk/rustdesk/releases/download/${VER}/rustdesk-${VER}.deb" -qO /tmp/rustdesk.deb
sudo dpkg -i /tmp/rustdesk.deb
rm /tmp/rustdesk.deb
