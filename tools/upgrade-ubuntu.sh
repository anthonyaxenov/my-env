#!/bin/bash
# https://dev.to/chefgs/upgrading-an-end-of-life-eol-ubuntu-os-to-lts-version-3a36
# https://changelogs.ubuntu.com/meta-release

installed() {
    command -v "$1" >/dev/null 2>&1
}

# sudo software-properties-qt (переключиться с LTS на нормальные релизы)
# sudo aptitude install update-manager-core update-manager
# sudo apt upgrade --autoremove -y
# installed pkcon && sudo pkcon update --autoremove -y
# sudo apt dist-upgrade
# sudo apt install update-manager-core
# sudo do-release-upgrade -p

source /etc/os-release

echo "Loading..."

IFS=$'\n' codenames=($(curl -s https://changelogs.ubuntu.com/meta-release | grep -xP "^Dist:\s[\w]+$" | sed "s/Dist: //" ))
thisCodename="$VERSION_CODENAME"
for idx in "${!codenames[@]}"; do
    if [ "${codenames[idx]}" = "$thisCodename" ]; then
        nextCodename=${codenames[((idx+1))]}
    fi
done

targetDownloadPath="`pwd`/upgrade-$nextCodename"
targetToolPath="$targetDownloadPath/unpacked"
targetToolFile="$targetDownloadPath/$nextCodename.tar.gz"

echo "Current dist: $thisCodename"
echo "Next dist:    $nextCodename"
echo "Target path:  $targetToolFile"

rm -rf "$targetToolPath"
mkdir -p "$targetToolPath"

echo "Downloading..."
cd "$targetDownloadPath"
wget "http://archive.ubuntu.com/ubuntu/dists/${nextCodename}-updates/main/dist-upgrader-all/current/${nextCodename}.tar.gz"

echo "Unpacking..."
tar -xaf "$targetToolFile" -C "$targetToolPath"

echo "Starting..."
cd unpacked
sudo ./$nextCodename
