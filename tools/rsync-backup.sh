#!/bin/bash

RS_SRC_DEV=/dev/sdb1
RS_DST_DEV=/dev/sdc1
LOG_DIR="/home/$USER/rsync-logs"
USE_NTFY=0
NTFY_TITLE="Backup: $RS_SRC_DEV => $RS_DST_DEV"
NTFY_CHANNEL=""

log() {
    [ ! -d "$LOG_DIR" ] && mkdir -p "$LOG_DIR"
    echo -e "[`date '+%H:%M:%S'`] $*" | tee -a "$LOG_DIR/`date '+%Y%m%d'`.log"
}

# отправляет простую нотификацию
ntfy_info() {
    [ $USE_NTFY == 1 ] && ntfy send \
        --title "$NTFY_TITLE" \
        --message "$1" \
        --priority 1 \
        "$NTFY_CHANNEL"
}

# отправляет нотификацию с предупреждением
ntfy_warn() {
    [ $USE_NTFY == 1 ] && ntfy send \
        --title "$NTFY_TITLE" \
        --tags "warning" \
        --message "$1" \
        --priority 5 \
        "$NTFY_CHANNEL"
}

log "START\t========================="

mnt_check=$(findmnt -nf "$RS_SRC_DEV")
if [ $? -gt 0 ]; then
    log "Source partition '$RS_SRC_DEV' is not mounted. Exit 1."
    exit 1
fi

RS_SRC_PATH=$(echo $mnt_check | awk '{ print $1 }')
log "Source partition '$RS_SRC_DEV' is mounted at '$RS_SRC_PATH'"

mnt_check=$(findmnt -nf "$RS_DST_DEV")
if [ $? -gt 0 ]; then
    log "Destination partition '$RS_DST_DEV' is not mounted. Exit 1."
    exit 1
fi

RS_DST_PATH=$(echo $mnt_check | awk '{ print $1 }')
log "Destination partition '$RS_DST_DEV' is mounted at '$RS_DST_PATH'"

log "Executing rsync:"

rsync -huva \
    --progress \
    --delete \
    --exclude='lost+found' \
    --exclude='.Trash' \
    "$RS_SRC_PATH/" \
    "$RS_DST_PATH/" \
    | while read line; do log "$line"; done

if [ $? -gt 0 ]; then
    log "Something went wrong. Exit 3."
    ntfy_warn "Something went wrong, check log"
    exit 3
fi
ntfy_info "Success!"

log "FINISH\t========================="
