#!/bin/bash
echo
echo "==============================================="
echo "Installing git..."
echo "==============================================="
echo

installed() {
    command -v "$1" >/dev/null 2>&1
}

if installed git; then
    [ ! -d "/usr/src/git" ] && sudo git clone https://github.com/git/git.git --depth=1 /usr/src/git
    sudo chown -R $USER: /usr/src/git
    cd /usr/src/git/
    sudo make prefix=/usr/local all
    sudo make prefix=/usr/local install
else
    sudo wget https://github.com/git/git/archive/master.zip -O /usr/src/git.zip
    sudo unzip /usr/src/git.zip -d /usr/src/git
    sudo rm -f /usr/src/git.zip
    cd /usr/src/git/git-master
    sudo make prefix=/usr/local all
    sudo make prefix=/usr/local install
    cd /usr/src
    sudo rm -rf git
    sudo git clone https://github.com/git/git.git --depth=1 /usr/src/git
    sudo chown -R $USER: /usr/src/git
fi
ENVDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cp "$ENVDIR"/dotfiles/.gitconfig $HOME/.gitconfig
git --version