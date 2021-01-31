#!/bin/sh

#######################################
# Utility Stuff for MC Scripts
#######################################

#### Reusable Variables

WORLD_NAME=$1
SCRIPT_PATH=$(dirname $0)

ROOT_PATH="/media/nfg/Storage/compose"
VOLUME_PATH="$ROOT_PATH/volumes/minecraft"
VOLATILE_LIVE_PATH="/dev/shm/$WORLD_NAME"

SERVER_PATH="$VOLUME_PATH/$WORLD_NAME"
ACTUAL_WORLD_PATH="$SERVER_PATH/world"
BACKUP_PATH="$VOLUME_PATH/backups/$WORLD_NAME"
BACKUP_LIVE_PATH="$BACKUP_PATH/live"
BACKUP_ARCHIVE_PATH="$BACKUP_PATH/archived"

#### Reusable Functions

calc_timestamp() {
    local _outval=$1
    local start=$2
    local end=`date +%s`
    local runtime=$((end-start))
    local elapsedStr="$((($runtime / 60) % 60))min $(($runtime % 60))sec"

    eval "$_outval=\$elapsedStr"
}

verify_server_exists() {
    if [ ! -d $SERVER_PATH ]; then
        echo "☠ World ($WORLD_NAME) does not exist."
        exit 99
    fi
}

move_world_to_memory() {
    echo "» Copying World to Memory..."

    start=`date +%s`

    rsync -rat $BACKUP_LIVE_PATH/world/ $VOLATILE_LIVE_PATH

    local elapsed
    calc_timestamp elapsed $start

    echo "   ✓ Live Backup Completed: $elapsed"
}