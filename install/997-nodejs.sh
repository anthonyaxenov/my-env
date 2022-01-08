#!/bin/bash
echo
echo "==============================================="
echo "Installing nodejs..."
echo "==============================================="
echo

installed() {
    command -v "$1" >/dev/null 2>&1
}

# sudo apt install -y --autoremove nodejs npm

if !installed "nvm"; then
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

if [ $(nvm current) == 'system' ]; then
    echo "WARNING: You already have node installed - removing to install actual version"
    sudo apt remove -y --autoremove nodejs npm
else
    nvm install-latest-npm
fi

nvm install node
nvm use node
installed "node" && nvm current
nvm ls
