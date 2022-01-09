#!/bin/bash
echo
echo "==============================================="
echo "Installing golang..."
echo "==============================================="
echo

# https://go.dev/dl/
# https://golang.org/doc/install
# https://www.vultr.com/docs/install-the-latest-version-of-golang-on-ubuntu

[ $1 ] && VERSION="$1" || VERSION="1.17.6"
FILE="go$VERSION.linux-amd64.tar.gz"

sudo rm -rf /usr/local/go
wget "https://golang.org/dl/$FILE" -O /tmp/$FILE
sudo tar -xzf $FILE -C /usr/local
rm -rf /tmp/$FILE
sudo chown $USER: -R /usr/local/go

echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile
echo "export GOPATH=~/.go" >> $HOME/.profile
# source ~/.profile

echo
go version
echo "NOTE: now run 'source ~/.profile' to apply new env vars"
echo