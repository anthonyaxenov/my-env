#!/bin/bash
echo
echo "==============================================="
echo "Installing anydesk..."
echo "==============================================="
echo

# http://deb.anydesk.com/howto.html

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
sudo sh -c "echo 'deb http://deb.anydesk.com/ all main'" > /etc/apt/sources.list.d/anydesk-stable.list
sudo apt install anydesk
