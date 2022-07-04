#!/bin/bash
# https://www.dev47apps.com/droidcam/linux/
# https://www.dev47apps.com/obs/
# https://www.dev47apps.com/obs/usage.html

echo
echo "==============================================="
echo "Installing droidcam-obs..."
echo "==============================================="
echo

command -v "obs" >/dev/null 2>&1 || echo 'You need to install obs first!'

mkdir -p ~/install/droidcam_obs
wget -O /tmp/droidcam-obs.zip https://files.dev47apps.net/obs/droidcam_obs_1.5.1_linux.zip
unzip -o /tmp/droidcam-obs.zip -d ~/install/droidcam-obs
rm -rf /tmp/droidcam-obs.zip
cd ~/install/droidcam-obs && ./install.sh

echo
echo "Don't forget to:"
echo "1) restart OBS if it is running right now"
echo "2) install android app: https://play.google.com/store/apps/developer?id=Dev47Apps"
echo
