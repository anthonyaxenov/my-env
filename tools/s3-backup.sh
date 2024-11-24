#!/bin/bash
#####################################################################
#                                                                   #
# Stupidly simple backup script for own projects                    #
#                                                                   #
# Author: Anthony Axenov (Антон Аксенов)                            #
# Version: 1.2                                                      #
# License: WTFPLv2                                                  #
# More info (RU): https://axenov.dev/?p=1272                        #
#                                                                   #
#####################################################################

# use remote storages ===============================================

USE_SSH=1
USE_S3=1

# database credentials ==============================================

DBUSER=
DBPASS=
DBNAME=
DBCHARSET="utf8"

# dates for file structure ==========================================

TODAY_DIR="$(date +%Y.%m.%d)"
TODAY_FILE="$(date +%H.%M)"

# local storage =====================================================

LOCAL_BAK_DIR="/backup"
LOCAL_BAK_PATH="$LOCAL_BAK_DIR/$TODAY_DIR"

# database backup file
LOCAL_SQL_FILE="$TODAY_FILE-db.sql.gz"
LOCAL_SQL_PATH="$LOCAL_BAK_PATH/$LOCAL_SQL_FILE"

# project path and backup file
LOCAL_SRC_DIR="/var/www/html"
LOCAL_SRC_FILE="$TODAY_FILE-src.tar.gz"
LOCAL_SRC_PATH="$LOCAL_BAK_PATH/$LOCAL_SRC_FILE"

# log file
LOG_FILE="$TODAY_FILE.log"
LOG_PATH="$LOCAL_BAK_PATH/$LOG_FILE"

# remote storages ===================================================

SSH_HOST="user@example.com"
SSH_BAK_DIR="/backup"
SSH_BAK_PATH="$SSH_BAK_DIR/$TODAY_DIR"
SSH_SQL_FILE="$SSH_BAK_PATH/$LOCAL_SQL_FILE"
SSH_SRC_FILE="$SSH_BAK_PATH/$LOCAL_SRC_FILE"
SSH_LOG_FILE="$SSH_BAK_PATH/$LOG_FILE"

S3_BUCKET="s3://my.bucket"
S3_DIR="$S3_BUCKET/$TODAY_DIR"
S3_SQL_FILE="$S3_DIR/$LOCAL_SQL_FILE"
S3_SRC_FILE="$S3_DIR/$LOCAL_SRC_FILE"
S3_LOG_FILE="$S3_DIR/$LOG_FILE"

# autoremove ========================================================

# time to live on different storages
TTL_LOCAL=3
TTL_SSH=7
TTL_S3=60

# autoremove flags
CLEAR_SSH=1
CLEAR_S3=1

# notifications =====================================================

USE_NTFY=1
NTFY_TITLE="Backup script"
NTFY_CHANNEL=

#====================================================================
#
# Functions used for the whole backup flow
#
#====================================================================

# prints arguments to stdout and into log file
log() {
    echo -e "[$(date +%H:%M:%S)] $*" | tee -a "$LOG_PATH"
}

# sends notification with information
ntfy_info() {
    [ $USE_NTFY == 1 ] && ntfy send \
        --title "$NTFY_TITLE" \
        --message "$1" \
        --priority 1 \
        "$NTFY_CHANNEL"
}

# sends notification with warning
ntfy_warn() {
    [ $USE_NTFY == 1 ] && ntfy send \
        --title "$NTFY_TITLE" \
        --tags "warning" \
        --message "$1" \
        --priority 5 \
        "$NTFY_CHANNEL"
}

# prints initialized parameters
show_params() {
    log "Initialized parameters:"

    log "├ [ Remotes ]"
    log "│\t├ USE_SSH = $USE_SSH"
    [ $USE_SSH == 1 ] && log "│\t├ SSH_HOST = $SSH_HOST"
    log "│\t├ USE_S3 = $USE_S3"
    [ $USE_S3 == 1 ] && log "│\t├ S3_BUCKET = $S3_BUCKET"

    log "├ [ Database ]"
    log "│\t├ DBUSER = $DBUSER"
    log "│\t├ DBNAME = $DBNAME"
    log "│\t├ DBCHARSET = $DBCHARSET"
    log "│\t├ LOCAL_SQL_PATH = $LOCAL_SQL_PATH"
    [ $USE_SSH == 1 ] && log "│\t├ SSH_SQL_FILE = $SSH_SQL_FILE"
    [ $USE_S3 == 1 ]  && log "│\t├ S3_SQL_FILE = $S3_SQL_FILE"

    log "├ [ Sources ]"
    log "│\t├ LOCAL_SRC_DIR = $LOCAL_SRC_DIR"
    log "│\t├ LOCAL_SRC_PATH = $LOCAL_SRC_PATH"
    [ $USE_SSH == 1 ] && log "│\t├ SSH_SRC_FILE = $SSH_SRC_FILE"
    [ $USE_S3 == 1 ]  && log "│\t├ S3_SRC_FILE = $S3_SRC_FILE"

    log "├ [ Log ]"
    log "│\t├ LOG_PATH = $LOG_PATH"
    [ $USE_SSH == 1 ] && log "│\t├ SSH_LOG_FILE = $SSH_LOG_FILE"
    [ $USE_S3 == 1 ]  && log "│\t├ S3_LOG_FILE = $S3_LOG_FILE"

    log "├ [ Autoclear ]"
    log "│\t├ TTL_LOCAL = $TTL_LOCAL"
    [ $USE_SSH == 1 ] && {
        log "│\t├ CLEAR_SSH = $CLEAR_SSH"
        log "│\t├ TTL_SSH = $TTL_SSH"
    }
    [ $USE_S3 == 1 ] && {
        log "│\t├ CLEAR_S3 = $CLEAR_S3"
        log "│\t├ TTL_S3 = $TTL_S3"
    }

    log "└ [ ntfy ]"
    log "\t├ USE_NTFY = $USE_NTFY"
    [ $USE_NTFY == 1 ] && log "\t├ NTFY_TITLE = $NTFY_TITLE"
    [ $USE_NTFY == 1 ] && log "\t└ NTFY_CHANNEL = $NTFY_CHANNEL"
}

# initializes directories for backup
init_dirs() {
    if [ ! -d "$LOCAL_BAK_PATH" ]; then
        mkdir -p $LOCAL_BAK_PATH
    fi
    [ $USE_SSH == 1 ] && ssh $SSH_HOST "mkdir -p $SSH_BAK_PATH"
}

# clears old local backups
clear_local_backups() {
    log "\tLocal:"
    log $(find "$LOCAL_BAK_DIR" -type d -mtime +"$TTL_LOCAL" | sort)
    find "$LOCAL_BAK_DIR" -type d -mtime +"$TTL_LOCAL" | xargs rm -rf
}

# clears old backups on remote ssh storage
clear_ssh_backups() {
    if [ $USE_SSH == 1 ] && [ $CLEAR_SSH == 1 ]; then
        log "\tSSH:"
        log $(ssh "$SSH_HOST" "find $SSH_BAK_DIR -type d -mtime +$TTL_SSH" | sort)
        ssh "$SSH_HOST" "find $SSH_BAK_DIR -type d -mtime +$TTL_SSH | xargs rm -rf"
    else
        log "\tSSH: disabled (\$USE_SSH, \$CLEAR_SSH)"
    fi
}

# clears backups on remote s3 storage
clear_s3_backups() {
    # https://gist.github.com/JProffitt71/9044744?permalink_comment_id=3539681#gistcomment-3539681
    if [ $USE_S3 == 1 ] && [ $CLEAR_S3 == 1 ]; then
        log "\tS3:"
        OLDER_THAN=$(date -d "$TTL_S3 days ago" "+%s")
        s3cmd ls -r $S3_DIR | while read -r line; do
            FILETIME=$(echo "$line" | awk {'print $1" "$2'})
            FILETIME=$(date -d "$FILETIME" "+%s")
            if [[ $FILETIME -le $OLDER_THAN ]]; then
                FILEPATH=$(echo "$line" | awk {'print $4'})
                if [ $FILEPATH != "" ]; then
                    log "$line"
                    s3cmd del $FILEPATH
                fi
            fi
        done
    else
        log "\tS3: disabled (\$USE_S3 + \$CLEAR_S3)"
    fi
}

# clears old backups
clear_backups() {
    echo
    log "1/7 Removing old backups..."
    clear_local_backups
    clear_ssh_backups
    clear_s3_backups
}

# makes archive with database dump
backup_db() {
    echo
    log "2/7 Dumping DB: $DBNAME..."
    mysqldump \
        --user=$DBUSER \
        --password=$DBPASS \
        --opt \
        --default-character-set=$DBCHARSET \
        --quick \
        $DBNAME | gzip > $LOCAL_SQL_PATH
    if [ $? == 0 ]; then
        log "\t- OK"
        send_db_ssh
        send_db_s3
    else
        log "\t- ERROR: failed to create dump. Exit-code: $?"
        ntfy_warn "ERROR: failed to create dump"
        log "3/7 Sending database backup to $SSH_HOST... skipped"
        log "4/7 Sending database backup to $S3_DIR... skipped"
    fi
}

# sends database archive into ssh remote storage
send_db_ssh() {
    echo
    log "3/7 Sending database backup to $SSH_HOST..."
    if [ $USE_SSH == 1 ]; then
        rsync --progress "$LOCAL_SQL_PATH" "$SSH_HOST:$SSH_SQL_FILE"
        if [ $? == 0 ]; then
            log "\t- OK"
        else
            log "\t- ERROR: failed to send DB backup to $SSH_HOST. Exit-code: $?"
            ntfy_warn "ERROR: failed to send DB backup to $SSH_HOST"
        fi
    else
        log "\t- disabled (\$USE_SSH)"
    fi
}

# sends database archive into s3 remote storage
send_db_s3() {
    echo
    log "4/7 Sending database backup to $S3_DIR..."
    if [ $USE_S3 == 1 ]; then
        s3cmd put "$LOCAL_SQL_PATH" "$S3_SQL_FILE"
        if [ $? == 0 ]; then
            log "\t- OK"
        else
            log "\t- ERROR: failed to send DB backup to $S3_DIR. Exit-code: $?"
            ntfy_warn "ERROR: failed to send DB backup to $S3_DIR"
        fi
    else
        log "\t- disabled (\$USE_SSH)"
    fi
}

# makes archive with project sources
backup_src() {
    echo
    log "5/7 Compressing project dir: $LOCAL_SRC_DIR..."
    tar -zcf "$LOCAL_SRC_PATH" "$LOCAL_SRC_DIR"
    if [ $? == 0 ]; then
        log "\t- OK"
        send_src_ssh
        send_src_s3
    else
        log "\t- ERROR: failed to compress project. Exit-code: $?"
        ntfy_warn "ERROR: failed to compress project"
        log "6/7 Sending project backup to $SSH_HOST... skipped"
        log "7/7 Sending project backup to $S3_DIR... skipped"
    fi
}

# sends sources archive into ssh remote storage
send_src_ssh() {
    echo
    log "6/7 Sending project backup to $SSH_HOST..."
    if [ $USE_SSH == 1 ]; then
        rsync --progress "$LOCAL_SRC_PATH" "$SSH_HOST:$SSH_SRC_FILE"
        if [ $? == 0 ]; then
            log "\t- OK"
        else
            log "\t- ERROR: failed to send project backup to $SSH_HOST. Exit-code: $?"
            ntfy_warn "ERROR: failed to send project backup to $SSH_HOST"
        fi
    else
        log "\t- disabled"
    fi
}

# sends sources archive into s3 remote storage
send_src_s3() {
    echo
    log "7/7 Sending project backup to $S3_DIR..."
    s3cmd put "$LOCAL_SRC_PATH" "$S3_SRC_FILE"
    if [ $? == 0 ]; then
        log "\t- OK"
    else
        log "\t- ERROR: failed to send database backup to $S3_DIR. Exit-code: $?"
        ntfy_warn "ERROR: failed to send project backup to $S3_DIR"
    fi
}

# prints used/free space on local storage
show_finish() {
    echo
    log "Finish!"
    log "Used space: $(du -h "$LOCAL_BAK_PATH" | tail -n1)" # вывод размера папки с бэкапами за текущий день
    log "Free space: $(df -h "$LOCAL_BAK_PATH" | tail -n1 | awk '{print $4}')" # вывод свободного места на локальном диске
    echo
}

# sends log file into both remote storage
send_log() {
    [ $USE_SSH == 1 ] && rsync --progress "$LOG_PATH" "$SSH_HOST:$SSH_LOG_FILE"
    [ $USE_S3 == 1 ] && s3cmd put "$LOG_PATH" "$S3_LOG_FILE"
}

# main flow =========================================================

log "Start ----------------------------------------------------------"
show_params
init_dirs
clear_backups
backup_db
backup_src
show_finish
send_log
ntfy_info "Finish!"
