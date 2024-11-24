#!/bin/bash
# https://gist.github.com/anthonyaxenov/b8336a2bc9e6a742b5a050fa2588d71e
#####################################################################
#                                                                   #
# Stupidly simple backup script for own projects                    #
#                                                                   #
# Author: Anthony Axenov (Антон Аксенов)                            #
# Version: 1.0                                                      #
# License: WTFPLv2    More info: https://axenov.dev/?p=1423         #
#                                                                   #
#####################################################################

# database credentials ==============================================

DBUSER=
DBPASS=
DBNAME=
DBCHARSET="utf8"

# date formats ======================================================

FMT_DT_DIR="%Y.%m.%d" # 2021.03.19
FMT_DT_FILE="%H.%M"   # 08.24
FMT_DT_LOG="%H:%M:%S" # 08:24:15.168149413

# local storage =====================================================

LOCAL_BAK_DIR="/backup/$(date +$FMT_DT_DIR)"

# database backup file
LOCAL_SQL_FILE="$(date +$FMT_DT_FILE)-db.sql.gz"
LOCAL_SQL_PATH="$LOCAL_BAK_DIR/$LOCAL_SQL_FILE"

# project path and backup file
LOCAL_SRC_DIR="/var/www/"
LOCAL_SRC_FILE="$(date +$FMT_DT_FILE)-src.tar.gz"
LOCAL_SRC_PATH="$LOCAL_BAK_DIR/$LOCAL_SRC_FILE"

# log file
LOG_FILE="$(date +$FMT_DT_FILE).log"
LOG_PATH="$LOCAL_BAK_DIR/$LOG_FILE"

log() {
    echo -e "[$(date +$FMT_DT_LOG)] $*" | tee -a "$LOG_PATH"
}

# remote storage ====================================================

REMOTE_HOST="user@example.com"
REMOTE_BAK_DIR="/backup/$(date +$FMT_DT_DIR)"
REMOTE_SQL_PATH="$REMOTE_BAK_DIR/$LOCAL_SQL_FILE"
REMOTE_SRC_PATH="$REMOTE_BAK_DIR/$LOCAL_SRC_FILE"
REMOTE_LOG_PATH="$REMOTE_BAK_DIR/$LOG_FILE"

# start =============================================================

echo
log "Start ----------------------------------------------------------------"
log "Initialized parameters:"
log "\tDB_USER\t\t= $DB_USER"
log "\tDB_NAME\t\t= $DB_NAME"
log "\tDB_CHARSET\t= $DB_CHARSET"
log "\tLOCAL_SRC_DIR\t= $LOCAL_SRC_DIR"
log "\tLOCAL_SRC_PATH\t= $LOCAL_SRC_PATH"
log "\tLOCAL_SQL_PATH\t= $LOCAL_SQL_PATH"
log "\tLOG_PATH\t= $LOG_PATH"
log "\tREMOTE_HOST\t= $REMOTE_HOST"
log "\tREMOTE_SQL_PATH\t= $REMOTE_SQL_PATH"
log "\tREMOTE_SRC_PATH\t= $REMOTE_SRC_PATH"
log "\tREMOTE_LOG_PATH\t= $REMOTE_LOG_PATH"

mkdir -p $LOCAL_BAK_DIR
log "Created local dir: $LOCAL_BAK_DIR"

ssh $REMOTE_HOST mkdir -p $REMOTE_BAK_DIR
log "Created remote dir: $REMOTE_BAK_DIR"

log "1/4 Dumping DB: $DBNAME..."
mysqldump \
    --user="$DBUSER" \
    --password="$DBPASS" \
    --default-character-set="$DBCHARSET" \
    --opt \
    --quick \
    "$DBNAME" | gzip > "$LOCAL_SQL_PATH"
# --opt    Same as --add-drop-table, --add-locks, --create-options,
#          --quick, --extended-insert, --lock-tables, --set-charset,
#          and --disable-keys
[ $? -gt 0 ] && log "ERROR: failed to create dump. Exit-code: $?" || log "\t- OK"

log "2/4 Sending database backup to $REMOTE_HOST..."
rsync --progress "$LOCAL_SQL_PATH" "$REMOTE_HOST:$REMOTE_SQL_PATH"
[ $? -gt 0 ] && log "ERROR: failed to send database backup. Exit-code: $?" || log "\t- OK"

log "3/4 Compressing project dir: $LOCAL_SRC_DIR..."
tar -zcf "$LOCAL_SRC_PATH" "$LOCAL_SRC_DIR"
[ $? -gt 0 ] && log "ERROR: failed to compress project. Exit-code: $?" || log "\t- OK"

log "4/4 Sending project backup to ${REMOTE_HOST}..."
rsync --progress "$LOCAL_SRC_PATH" "$REMOTE_HOST:$REMOTE_SRC_PATH"
[ $? -gt 0 ] && log "ERROR: failed to send project backup. Exit-code: $?" || log "\t- OK"

rsync --progress "$LOG_PATH" "$REMOTE_HOST:$REMOTE_LOG_PATH"

log "Finish!"
log "Used space: $(du -h "$LOCAL_BAK_DIR" | tail -n1)"
log "Free space: $(df -h | tail -n1 | awk '{print $4}')"
