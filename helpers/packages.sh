#!/bin/bash
source $(dirname $0)/io.sh || exit 255

########################################################
# Functions to control system packages
########################################################

installed() {
    command -v "$1" >/dev/null 2>&1
}

installed_deb() {
    dpkg --list | grep -qw "ii  $1"
}

apt_install() {
    sudo apt install -y --autoremove $*
}

require() {
    sw=()
    for package in "$@"; do
        if ! installed "$package" && ! installed_deb "$package"; then
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
        if ! installed "$package" && ! installed_deb "$package"; then
            sw+=("$package")
        fi
    done
    if [ ${#sw[@]} -gt 0 ]; then
        die "These packages must be installed in your system:\n${sw[*]}" 200
    fi
}
