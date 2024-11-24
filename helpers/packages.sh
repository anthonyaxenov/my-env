#!/bin/bash
source $( dirname $(readlink -e -- "${BASH_SOURCE}"))/io.sh || exit 255

########################################################
# Functions to control system packages
########################################################

installed() {
    command -v "$1" >/dev/null 2>&1
}

installed_pkg() {
    dpkg --list | grep -qw "ii  $1"
}

apt_ppa_add() {
    sudo add-apt-repository -y $*
}

apt_ppa_remove() {
    sudo add-apt-repository -ry $*
}

apt_update() {
    sudo apt update $*
}

apt_install() {
    sudo apt install -y $*
}

apt_remove() {
    sudo apt purge -y $*
}

dpkg_install() {
    sudo dpkg -i $*
}

dpkg_remove() {
    sudo dpkg -r $*
}

dpkg_arch() {
    dpkg --print-architecture
}

require() {
    sw=()
    for package in "$@"; do
        if ! installed "$package" && ! installed_pkg "$package"; then
            sw+=("$package")
        fi
    done
    if [ ${#sw[@]} -gt 0 ]; then
        info "These packages will be installed in your system:\n${sw[*]}"
        apt_install ${sw[*]}
        [ $? -gt 0 ] && die "installation cancelled" 201
    fi
}

require_pkg() {
    sw=()
    for package in "$@"; do
        if ! installed "$package" && ! installed_pkg "$package"; then
            sw+=("$package")
        fi
    done
    if [ ${#sw[@]} -gt 0 ]; then
        die "These packages must be installed in your system:\n${sw[*]}" 200
    fi
}
