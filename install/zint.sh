#!/bin/bash
##makedesc: Install zint (latest)

echo
echo "==============================================="
echo "Installing zint (latest)..."
echo "==============================================="
echo

sudo apt install -y --autoremove \
    g++ \
    cmake \
    qtbase5-dev \
    qttools5-dev \
    libpng-dev

if installed git; then
    # 2.9.* ===============================================================================
    sudo git clone git@github.com:zint/zint.git /usr/src/zint
    cd /usr/src/zint
    sudo cmake .
    sudo make
    sudo make install
else
    echo "You need git to be installed!"
    # 2.4.2 ===============================================================================
    # https://wayneoutthere.com/2021/02/17/how-to-install-zint-on-ubuntu/
    # sudo wget https://github.com/downloads/zint/zint/zint-2.4.2.tar.gz -O /usr/src/zint.tar.gz
    # sudo tar -C /usr/src/ -xzf /usr/src/zint.tar.gz
    # sudo rm -rf /usr/src/zint.tar.gz
    # cd /usr/src/zint-2.4.2/build
    # sudo cmake ..
    # sudo make
    # sudo make install
    # sudo rm -rf /usr/src/zint*
    # cd -
fi
