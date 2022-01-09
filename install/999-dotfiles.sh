#!/bin/bash
echo
echo "==============================================="
echo "Installing dotfiles..."
echo "==============================================="
echo

ENVDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DOTFILESDIR="$ENVDIR"/dotfiles

cp $DOTFILESDIR/.bash_aliases $HOME/.bash_aliases
cp $DOTFILESDIR/.bashrc $HOME/.bashrc
cp $DOTFILESDIR/.zshrc $HOME/.zshrc
cp $DOTFILESDIR/.gitconfig $HOME/.gitconfig
cp -R $DOTFILESDIR/Шаблоны $HOME/Шаблоны
