#!/bin/bash
##makedesc: Install git (latest)

echo
echo "==============================================="
echo "Installing git (latest)..."
echo "==============================================="
echo

installed() {
    command -v "$1" >/dev/null 2>&1
}
ENVDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

! installed make && sudo apt install -y make

if installed git; then
    sudo rm -rf /usr/src/git
    sudo git clone https://github.com/git/git.git --depth=1 /usr/src/git
    sudo chown -R $USER: /usr/src/git
    cd /usr/src/git/
    sudo make prefix=/usr/local all
    sudo make prefix=/usr/local install
else
    ! installed wget && sudo apt install -y wget
    wget https://github.com/git/git/archive/master.zip -O /tmp/git.zip
    sudo unzip -q /tmp/git.zip -d /usr/src/git
    rm /tmp/git.zip
    cd /usr/src/git/git-master
    sudo make prefix=/usr/local all
    sudo make prefix=/usr/local install
    cd /usr/src
    sudo rm -rf git
    sudo git clone https://github.com/git/git.git --depth=1 /usr/src/git
    sudo chown -R $USER: /usr/src/git
fi

git --version
