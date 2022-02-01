#!/bin/bash
echo
echo "==============================================="
echo "Installing anydesk..."
echo "==============================================="
echo

# http://deb.anydesk.com/howto.html

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo 'deb http://deb.anydesk.com/ all main' | sudo tee /etc/apt/sources.list.d/anydesk-stable.list > /dev/null
sudo apt update && sudo apt install anydesk
