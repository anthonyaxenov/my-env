#!/bin/bash
##makedesc: Install golang v1.18.3

# https://go.dev/dl/
# https://golang.org/doc/install
# https://www.vultr.com/docs/install-the-latest-version-of-golang-on-ubuntu


[ $1 ] && VERSION="$1" || VERSION="1.18.3"
FILE="go$VERSION.linux-amd64.tar.gz"

echo
echo "==============================================="
echo "Installing golang v$VERSION..."
echo "==============================================="
echo

sudo rm -rf /usr/local/go && \
    wget "https://golang.org/dl/$FILE" -O /tmp/$FILE && \
    sudo tar -xzf /tmp/$FILE -C /usr/local && \
    rm -rf /tmp/$FILE && \
    sudo chown $USER: -R /usr/local/go && \
    echo 'export PATH="$PATH:/usr/local/go/bin\"' >> $HOME/.profile && \
    echo 'export GOPATH="$HOME/.go"' >> $HOME/.profile && \
    # source ~/.profile && \
    go version && \
    echo "NOTE: now run 'source ~/.profile' to apply new env vars"
