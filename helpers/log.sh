#!/bin/bash

########################################################
# Logging functions
########################################################

# write some message $1 in log file and stdout with timestamp
log_path="/home/$USER/logs"
log() {
    [ ! -d "$log_path" ] && log_path="./log"
    [ ! -d "$log_path" ] && mkdir -p "$log_path"
    echo -e "[$(date '+%H:%M:%S')] $*" | tee -a "$log_path/$(date '+%Y%m%d').log"
}
