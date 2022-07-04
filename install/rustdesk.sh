#!/bin/bash
##makedesc: Install rustdesk v1.1.8 (deb)

[ $1 ] && RDVER="$1" || RDVER="1.1.8"
echo
echo "==============================================="
echo "Installing rustdesk v${RDVER}..."
echo "==============================================="
echo

# https://github.com/rustdesk/rustdesk

sudo apt install libxdo3
wget "http://github.com/rustdesk/rustdesk/releases/download/${RDVER}/rustdesk-${RDVER}.deb" -qO /tmp/rustdesk.deb
sudo dpkg -i /tmp/rustdesk.deb
rm /tmp/rustdesk.deb
