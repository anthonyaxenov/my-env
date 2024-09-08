#!/bin/bash
# Очистка места на диске
# https://gist.github.com/anthonyaxenov/02c00c965be4eb5bb163a153abdf4c2b
# https://itsfoss.com/free-up-space-ubuntu-linux/

df -h
echo ""
echo "[1/5] Removing apt caches and unused packages"
echo ""

sudo apt autoremove --purge
sudo apt autoclean
sudo apt clean

echo ""
echo "[2/5] Removing old journalctl logs"
echo ""

sudo journalctl --vacuum-time=1d
sudo rm -rf /var/log/journal/user-*@*
sudo rm -rf /var/log/journal/system*@*

echo ""
echo "[3/5] Cleaning user trash and thumbnails"
echo ""

rm -rf ~/.local/share/Trash/files/*
rm -rf ~/.cache/thumbnails/*

echo ""
echo "[4/5] Cleaning out dangling docker objects"
echo ""

docker system prune -f
# docker system prune -af

echo ""
echo "[5/5] Removing disabled unused snaps"
echo ""

sudo snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        sudo snap remove "$snapname" --revision="$revision"
    done

echo ""
echo ""
df -h
