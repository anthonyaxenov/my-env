#!/bin/bash
echo
echo "==============================================="
echo "Installing syncthing..."
echo "==============================================="
echo

# https://apt.syncthing.net/

# Add the release PGP keys:
sudo curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

# Add the "stable" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Add the "candidate" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing candidate" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Update and install syncthing:
sudo apt update
sudo apt install -y --autoremove syncthing

wget "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-start.desktop" -O /home/anthony/.local/share/applications/syncthing-start.desktop
wget "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-ui.desktop" -O /home/anthony/.local/share/applications/syncthing-ui.desktop
ln -s /home/anthony/.local/share/applications/syncthing-start.desktop /home/anthony/.config/autostart/syncthing-start.desktop
# или демоном: https://habr.com/ru/post/350892/
