#!/bin/sh

#############################################
# Utility Stuff for MC Scripts
#############################################

#### Reusable Variables

# Only set on the first time including
SCRIPT_PATH=$(dirname $0)

LIVE_PATH="/mc/live"
ARCHIVE_PATH="/mc/archived"
VOLATILE_PATH="/mc/volatile"
SERVER_PATH="/data"

SEMAPHORE_PATH="$SERVER_PATH/.ramdisk_setup"
LIVE_WORLD_PATH="$LIVE_PATH/world"
SERVER_WORLD_PATH="$SERVER_PATH/world"

LATEST_ARCHIVE_FILENAME="latest.tar.gz"

#### Reusable Functions

calc_timestamp() {
    local _outval=$1
    local start=$2
    local end=`date +%s`
    local runtime=$((end-start))
    local elapsedStr="$((($runtime / 60) % 60))min $(($runtime % 60))sec"

    eval "$_outval=\$elapsedStr"
}

# Call out to backup script
perform_live_backup() {
    echo -e '\tPerforming Live Backup (external script)...'
    sh $SCRIPT_PATH/backup_mc.sh >> /dev/null 2>&1
}

# Call out to backup script
perform_full_backup() {
    echo -e '\tPerforming Live and Archived Backup (external script)...'
    sh $SCRIPT_PATH/backup_mc.sh true >> /dev/null 2>&1
}

# Syncs the Live Backup to the Volatile Memory Path
move_world_to_memory() {
    echo -e "\t\t» Copying World to Memory..."

    start=`date +%s`

    rsync -rat $LIVE_WORLD_PATH/ $VOLATILE_PATH

    local elapsed
    calc_timestamp elapsed $start

    echo -e "\t\t\t✔️ Live Backup Completed: $elapsed"
}