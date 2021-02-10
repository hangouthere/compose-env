#!/bin/sh

. "$(dirname $0)/_util.sh"

#############################################
# Setup MC World State: Configured Run
#############################################

: <<'NOTES'

- Verify world has files
    - If not, verify Live Backup exists, and do nothing (later ops will ensure proper state)
    - If not, verify Archived Backup exists
        - If not, throw error and exit. Something bad happened!
        - If so, restore to Live Backup location
- Do a quick backup (see backup_mc.sh)
    - Live backup only
- Copy world to volatile space
- Delete world from disk
- Verify symlink
    - If not, Symlink volatile space to disk

-- Troubleshooting --

Exit Codes:

 - 0: Nothing wrong! This is desirable!
 - 99: World missing, cannot recover
 - 98: World missing, could not recover archive backup

NOTES

ATTEMPTED_VERIFY=0

verify_world_state() {
    echo -e "\t\t✔️ Detected setup, verifying it's still valid..."

    numFiles=$(ls -1 $SERVER_WORLD_PATH 2>/dev/null | wc -l)

    # Test if we have world files...
    if [ ! "$numFiles" -gt 0 ]; then
        echo -e "\t\t💀 World files missing, checking for backups..."

        check_for_existing_backups
    else
        echo -e "\t\t✔️ World files detected, continuing launch..."
    fi

    ATTEMPTED_VERIFY=$(($ATTEMPTED_VERIFY + 1))
}

check_for_existing_backups() {
    # Test if our Live Backup has a world...
    if [ -d "$LIVE_WORLD_PATH" ]; then
        echo -e "\t\t\t✔️ Live Backup detected, we should be good!"
        
        move_world_to_memory
    else
        echo -e "\t\t\t💀 Live Backup files missing, checking for archived backups..."
        attempt_archived_recovery
    fi
}

attempt_archived_recovery() {
    archiveName="$ARCHIVE_PATH/$LATEST_ARCHIVE_FILENAME"

    # Test if our Archived Backup exists...
    if [ -f "$archiveName" ]; then
        # Restore latest archive to our Live Path
        tar -xzf $archiveName -C $LIVE_PATH 2>/dev/null

        if [ "$?" -ne 0 ]; then
            echo -e "\t\t\t💀 Archive recovery failed! Cannot continue, catastrophic failure!"
            exit 98
        fi

        echo -e "\t\t\t✔️ Archive Backup restored! Retesting Setup!"
        
        verify_world_state

        move_world_to_memory
    else
        echo -e "\t\t\t💀 'Latest' Archive Backup file missing, catastrophic failure!"
        exit 97
    fi
}

resume_world() {
    echo -e "\t» Configured launch, resuming world..."

    perform_live_backup
    verify_world_state

    touch $SEMAPHORE_PATH
}

###################################################

resume_world