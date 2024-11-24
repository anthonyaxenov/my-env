#!/bin/bash

sudo apt update && sudo apt upgrade -y --autoremove
sudo apt install -y \
    alien \
    apt-transport-https \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    dconf-editor \
    default-jdk \
    dialog \
    gettext \
    gnupg \
    gparted \
    hardinfo \
    htop \
    libaio1 \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    libghc-zlib-dev \
    libssl-dev \
    lsb-release \
    lsp-plugins \
    make \
    mc \
    nano \
    neofetch \
    net-tools \
    nmap \
    p7zip-full \
    easyeffects \
    software-properties-common \
    ubuntu-restricted-extras \
    unzip \
    vlc \
    ffmpeg \
    xclip \
    inotify-tools \
    notify-osd \
    fonts-open-sans \
    libnotify-bin \
    gnome-software \
    gnome-software-plugin-flatpak \
    gnome-software-plugin-snap \
    terminator \
    geoclue-2.0 \
    redshift \
    redshift-gtk \
    samba \
    dkms


# https://selectel.ru/blog/tutorials/how-to-install-and-configure-samba-on-ubuntu-20-04/
# https://linuxconfig.org/how-to-configure-samba-server-share-on-ubuntu-22-04-jammy-jellyfish-linux
# https://phoenixnap.com/kb/ubuntu-samba
# https://computingforgeeks.com/install-and-configure-samba-server-share-on-ubuntu/
# https://linux.how2shout.com/how-to-install-samba-on-ubuntu-22-04-lts-jammy-linux/
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
sudo bash -c 'grep -v -E "^#|^;" /etc/samba/smb.conf.bak | grep . > /etc/samba/smb.conf'
sudo systemctl enable --now smbd
sudo usermod -aG sambashare $USER
sudo smbpasswd -a $USER




sudo add-apt-repository -y ppa:agornostal/ulauncher && \
    sudo apt install -y --autoremove ulauncher

curl -L https://yt-dl.org/downloads/latest/youtube-dl -o "${HOME}/.local/bin/youtube-dl" && \
    sudo chmod +rx "${HOME}/.local/bin/youtube-dl"

wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" && \
    sudo dpkg -i google-chrome-stable_current_amd64.deb

git clone https://github.com/aircrack-ng/rtl8812au.git && \
    cd rtl8812au && \
    sudo make dkms_install

sudo curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list && \
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing candidate" | sudo tee /etc/apt/sources.list.d/syncthing.list && \
    sudo apt update && sudo apt install -y --autoremove syncthing && \
    wget "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-start.desktop" -O $HOME/.local/share/applications/syncthing-start.desktop && \
    wget "https://raw.githubusercontent.com/syncthing/syncthing/main/etc/linux-desktop/syncthing-ui.desktop" -O $HOME/.local/share/applications/syncthing-ui.desktop && \
    ln -sf $HOME/.local/share/applications/syncthing-start.desktop $HOME/.config/autostart/syncthing-start.desktop



#####################################################################

sudo apt install -y kodi kodi-pvr-iptvsimple



























