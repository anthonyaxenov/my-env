#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing docker..."

# https://docs.docker.com/engine/install/ubuntu/

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
# sudo apt update
# apti docker-ce docker-compose

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
apti docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker anthony

success "You need to logout and log in again to apply docker group"
