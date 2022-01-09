#!/bin/bash
set -e
OLDDIR=`pwd`
ENVDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
INSTALLDIR="$ENVDIR"/install
DOTFILESDIR="$ENVDIR"/dotfiles

for script in "$INSTALLDIR"/*.sh
do
    . "$script"
done
