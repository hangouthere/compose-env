#!/bin/sh

. "$(dirname $0)/_util.sh"

#############################################
# Backup MC World
#############################################

: <<'NOTES'

Usage:
    backup_mc [archive:true?]

* This script always assumes paths exist!
* Always runs a "live" backup

Two kinds of backups:
    - Live: this is a backup to quickly recover from, but not what the server
      uses to operate.
    - Archived: this is a more permanent backup, which excludes cached files
      and useful for catastrophic failures. Archived backups are made from the
      last Live Backup.

NOTES

# Backs up the entire server contents (minus any excludes)
#  to another place on disk, for safety.
# This also works when a symlink is in-place, so there's
#  no need to do memory->live checks/backup specifically.
perform_live_backup() {
    echo "» Doing Live Backup..."

    start=`date +%s`

    rsync -rat --copy-links --exclude-from $SCRIPT_PATH/_excludes.txt $SERVER_PATH/ $LIVE_PATH #note trailing slash!

    local elapsed
    calc_timestamp elapsed $start

    echo -e "\t✔️ Live Backup Completed: $elapsed"
}

# Archive from the Live Path
perform_archived_backup() {
    ts=$(date +"%Y.%m.%d-%H.%M.%S")
    archiveFilename="$ts.tar.gz"

    echo "» Doing Archived Backup..."
    tar --exclude-from=$SCRIPT_PATH/_excludes.txt -C $LIVE_PATH -czf $ARCHIVE_PATH/$archiveFilename ./

    cd $ARCHIVE_PATH

    # Re-link 'latest' filename to the actual latest file just created
    rm -f $LATEST_ARCHIVE_FILENAME
    ln -s $archiveFilename $LATEST_ARCHIVE_FILENAME

    local elapsed
    calc_timestamp elapsed $start

    echo -e "\t✔️ Archived Backup Completed: $elapsed"
}

perform_backups() {
    perform_live_backup

    if [ "$1" == "true" ]; then
        perform_archived_backup
    fi
}

###################################################

perform_backups $@