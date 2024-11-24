#!/bin/bash
# My use case:
# syncthing synchronizes ALL changes in DCIM directory on my android to PC.
# I wanted files to be copied somewhere else on my PC to stay forever, so I
# could sort them later and safely free some space on mobile without loss.
# Also I wish to have some stupid log with history of such events.

# inotify-tools package must be installed!

# CHANGE THIS PARAMETERS to ones you needed
dir_src="$HOME/Syncthing/Mobile/Camera"
dir_dest="$HOME/some/safe/place"
dir_logs="$HOME/inotifywait-cp-logs"
regexp="[0-9]{8}_[0-9]{6}.*\.(jpg|mp4|gif)"

print() {
    echo -e "[`date '+%H:%M:%S'`] $*" \
    | tee -a "$dir_logs/`date '+%Y%m%d'`.log"
}

copy () {
    mkdir -p "$dir_src" "$dir_dest" "$dir_logs"
    if [ -f "$dir_dest/$1" ]; then
        print "SKIPPED:\t$dir_dest/$1"
    else
        cp "$dir_src/$1" "$dir_dest/$1"
        print "COPIED:\t$dir_src/$1 => $dir_dest/$1"
    fi
}

mkdir -p "$dir_src" "$dir_dest" "$dir_logs"

print "START\t========================="

# First, try to backup files synced since last exec of this script
ls -1 "$dir_src" \
| grep -E "^$regexp$" \
| while read filename; do copy "$filename"; done

# Next, run inotifywait against source directory with args:
# --quiet     -- print less (only print events)
# --monitor   -- don't stop after first event (like infinite loop)
# --event     -- first syncthing creates hidden file to write data into
#                then renames it according to source file name, so here
#                we listen to MOVED_TO event to catch final filename
# --format %f -- print only filename
# --include   -- filename regexp to catch event from, ensure your $regexp
#                is correct or remove line 56 to catch synced ALL files

inotifywait \
    --quiet \
    --monitor \
    --event moved_to \
    --format %f \
    --include "$regexp" \
    "$dir_src" \
    | while read filename; do copy "$filename"; done

print "FINISH\t========================="
