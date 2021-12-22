#!/bin/bash
. "../src/01-common.sh" || exit 5
title "Installing golang"

# https://golang.org/doc/install
# https://www.vultr.com/docs/install-the-latest-version-of-golang-on-ubuntu

# if [ "$EUID" -ne 0 ]
#   then echo "*** root permissions required ***"
#   exit
# fi

[ $1 ] && VERSION="$1" || VERSION="1.17.5"
FILE="go$VERSION.linux-amd64.tar.gz"

sudo rm -rf /usr/local/go
wget "https://golang.org/dl/$FILE" -O /tmp/$FILE
sudo tar -xzf $FILE -C /usr/local
rm -rf /tmp/$FILE
sudo chown $USER: -R /usr/local/go

echo "export PATH=$PATH:/usr/local/go/bin" >> /home/anthony/.profile
echo "export GOPATH=~/.go" >> /home/anthony/.profile
# source ~/.profile

success "$(go version)"
info "NOTE: now run \`source ~/.profile\` to apply new env vars"
