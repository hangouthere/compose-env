#!/bin/sh

. "$(dirname $0)/_util.sh"

#######################################
# Setup MC World Backup Stuffs
#######################################

# Order of Operations:
#   - Check if world exists
#   - Setup backup locations
#     - Live backup
#     - Archived backup
#     - Volatile
#   - Do a quick backup (see backup_mc_world.sh)
#     - Live backup
#     - Archived backup
#   - Copy existing world to memory
#   - Delete world from disk
#   - Symlink memory-world to disk
#   - ???
#   - Profit?

# Setup Backup Paths
setup_all_paths() {
    if [ ! -d $BACKUP_LIVE_PATH ]; then
        echo "» Creating Live Backup Path:\n  $BACKUP_LIVE_PATH"
        mkdir -p $BACKUP_LIVE_PATH
    else
        echo "» Live Backup Path already exists:\n  $BACKUP_LIVE_PATH"
    fi

    if [ ! -d $BACKUP_ARCHIVE_PATH ]; then
        echo "» Creating Archive Backup Path:\n  $BACKUP_ARCHIVE_PATH"
        mkdir -p $BACKUP_ARCHIVE_PATH
    else
        echo "» Archive Backup Path already exists:\n  $BACKUP_ARCHIVE_PATH"
    fi

    if [ ! -L $VOLATILE_LIVE_PATH ]; then
        echo "» Creating Live Volatile Path:\n  $VOLATILE_LIVE_PATH"
        mkdir -p $VOLATILE_LIVE_PATH
    else
        echo "» Live Volatile Path already exists:\n  $BACKUP_ARCHIVE_PATH"
    fi
}

# Call out to backup script
perform_backup() {
    sh $SCRIPT_PATH/backup_mc_world.sh $WORLD_NAME true
}

# Setup Symlink for worlds
setup_symlink() {
    # Symlink the world to the volatile memory path
    if [ ! -L $ACTUAL_WORLD_PATH ]; then
        echo "» Creating Live Volatile Symlink:\n  $ACTUAL_WORLD_PATH -> $VOLATILE_LIVE_PATH"
        rm -rf $ACTUAL_WORLD_PATH
        ln -s $VOLATILE_LIVE_PATH $ACTUAL_WORLD_PATH
    else
        echo "» Live Volatile Symlink already exists:\n  $ACTUAL_WORLD_PATH"
    fi
}

verify_server_exists
setup_all_paths
perform_backup
move_world_to_memory
setup_symlink