#!/bin/sh

. "$(dirname $0)/_util.sh"

#######################################
# Backup MC World
#######################################

# Utility functions to perform backups!
# Always runs a "live" backup, but has the option to also archive the live backup

# Usage:
# backup_mc_world <worldName> [archive:true?]

perform_live_backup() {
    echo "» Doing Live Backup..."

    start=`date +%s`

    rsync -rat --copy-links --exclude-from $SCRIPT_PATH/_excludes.txt $SERVER_PATH/ $BACKUP_LIVE_PATH

    local elapsed
    calc_timestamp elapsed $start

    echo "   ✓ Live Backup Completed: $elapsed"
}

perform_archived_backup() {
    ts=$(date -u +"%Y.%m.%d-%H.%M.%S")
    archiveName="$BACKUP_ARCHIVE_PATH/$ts.tar.gz"
    latestArchiveName="$BACKUP_ARCHIVE_PATH/latest.tar.gz"

    echo "» Doing Archived Backup..."
    tar --exclude-from=$SCRIPT_PATH/_excludes.txt -C $BACKUP_LIVE_PATH -czf $archiveName ./

    rm $latestArchiveName
    ln -s $archiveName $latestArchiveName

    local elapsed
    calc_timestamp elapsed $start

    echo "   ✓ Archived Backup Completed: $elapsed"
}

verify_server_exists
perform_live_backup

if [ $2 = "true" ]; then
    perform_archived_backup
fi