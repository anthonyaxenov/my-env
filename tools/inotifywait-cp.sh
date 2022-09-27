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

# Arguments description:
# --quiet     -- print less (only print events)
# --monitor   -- don't stop after first event (like infinite loop)
# --event     -- first syncthing creates hidden file to write data into
#                then renames it according to source file name, so here
#                we listen to MOVED_TO event to catch final filename
# --format %f -- print only filename
# --include   -- filename regexp to catch event from, ensure your $regexp
#                is correct or remove line 32 to catch synced ALL files

mkdir -p "$dir_dest" "$dir_logs"
inotifywait \
    --quiet \
    --monitor \
    --event moved_to \
    --format %f \
    --include "$regexp" \
    "$dir_src" \
    | while read filename; do
        cp "$dir_src/$filename" "$dir_dest/$filename"
        echo "[`date '+%H:%M:%S'`] COPIED: $dir_src/$filename => $dir_dest/$filename" \
        | tee -a "$dir_logs/`date '+%Y%m%d'`.log"
    done
