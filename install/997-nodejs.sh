#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing nodejs..."

# apti nodejs npm

if !installed "nvm"; then
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi
if [ $(nvm current) == 'system' ]; then
    warning "You already have node installed - removing to install actual version"
    sudo apt remove -y --autoremove nodejs npm
else
    nvm install-latest-npm
fi
nvm install node
nvm use node
installed "node" && success "nodejs installed! $(nvm current)"
installed "npm" && success "npm installed! $(nvm current)"
nvm ls
