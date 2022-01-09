#!/bin/bash
echo
echo "==============================================="
echo "Installing git..."
echo "==============================================="
echo

if installed git; then
    [ ! -d "/usr/src/git" ] && sudo git clone https://github.com/git/git.git --depth=1 /usr/src/git
    sudo chown -R anthony: /usr/src/git
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
    sudo chown -R anthony: /usr/src/git
fi
git config set --global user.name 'AnthonyAxenov'
git config set --global user.email 'anthonyaxenov@gmail.com'
git --version
# TODO: cp $DOTFILESDIR/.gitconfig $HOME/.gitconfig
