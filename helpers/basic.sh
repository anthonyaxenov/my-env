#!/bin/bash
source $( dirname $(readlink -e -- "${BASH_SOURCE}"))/io.sh || exit 255

########################################################
# Little handy helpers for scripting
########################################################

# convert relative path $1 to full one
abspath() {
    echo $(realpath -q "${1/#\~/$HOME}")
}

# check if path $1 is writable
is_writable() {
    [ -w "$(abspath $1)" ]
}

# check if path $1 is a directory
is_dir() {
    [ -d "$(abspath $1)" ]
}

# check if path $1 is a file
is_file() {
    [ -f "$(abspath $1)" ]
}

# check if an argument is a shell function
is_function() {
    declare -F "$1" > /dev/null
}

# check if string $1 matches regex $2
regex_match() {
    printf "%s" "$1" | grep -qP "$2"
}

# check if array $2 contains string $1
in_array() {
	local find=$1
    shift
    for e in "$@"; do
        [[ "$e" == "$find" ]] && return 0
    done
    return 1
}

# join all elements of array $2 with delimiter $1
implode() {
    local d=${1-}
    local f=${2-}
    if shift 2; then
        printf %s "$f" "${@/#/$d}"
    fi
}

# open url $1 in system web-browser
open_url() {
    if which xdg-open > /dev/null; then
        xdg-open "$1" </dev/null >/dev/null 2>&1 & disown
    elif which gnome-open > /dev/null; then
        gnome-open "$1" </dev/null >/dev/null 2>&1 & disown
    fi
}

# unpack .tar.gz file $1 into path $2
unpack_targz() {
    require tar
    tar -xzf "$1" -C "$2"
}

# make soft symbolic link of path $1 to path $2
symlink() {
    ln -sf "$1" "$2"
}

# download file $1 into path $2 using wget
download() {
    require wget
    wget "$1" -O "$2"
}

# download file $1 into path $2 using curl
cdownload() {
    require curl
    curl -fsSL "$1" -o "$2"
}
