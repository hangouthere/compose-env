#!/bin/sh

. "$(dirname $0)/_util.sh"

#############################################
# Setup MC World State: Unconfigured Run
#############################################

: <<'NOTES'

- If NO WORLD DETECTED, server has NEVER started:
    * No backups done, since there is nothing to backup
    - Establish symlink for world folder linking to Volatile Location
- If WORLD DETECTED, server HAS started, and we're porting to Volatile Location:
    - Do a quick backup (see backup_mc.sh)
        - Live backup
        - Archived backup
    - Establish symlink for world folder linking to Volatile Location
- Server should start and write to Volatile Location
- Always write semaphore indicating setup has been done, just to be safe

NOTES

detect_world() {
    # Server World not found, assuming never ran!
    #  This includes if your resolved symlink is missing (i.e., your RAM Drive is cleared out)
    if [ ! -d "$SERVER_WORLD_PATH" ]; then
        new_server
    else
        existing_server
    fi
}

new_server() {
    echo -e "\t\t» Existing Server State UNDETECTED, assuming first-ever launch..."
    setup_symlink
}

existing_server() {
    echo -e "\t\t» Existing Server State DETECTED, setting up for Volatile Location..."
    perform_full_backup
    setup_symlink
    move_world_to_memory
}

# Setup Symlink for worlds
setup_symlink() {
    # Symlink the world to the volatile memory path
    if [ -L "$SERVER_WORLD_PATH" ]; then
        echo -e "\t\t\t✔️ Live Volatile Symlink already exists: $SERVER_WORLD_PATH -> $VOLATILE_PATH"
    else
        echo -e "\t\t\t» Creating Live Volatile Symlink:"

        rm -rf $SERVER_WORLD_PATH
        echo -e "\t\t\t\t✔️ Force removed existing Server World Path"
        ln -sf $VOLATILE_PATH $SERVER_WORLD_PATH
        echo -e "\t\t\t\t✔️ Link Established: $SERVER_WORLD_PATH -> $VOLATILE_PATH"
    fi

    # Make sure the files are writable by the correct (aka server) user
    chown -R minecraft.minecraft $SERVER_WORLD_PATH/  #note trailing slash!
    echo -e "\t\t\t✔️ Made Server World Path writeable"
}

configure_world() {
    echo -e "\t❓ Unconfigured launch, doing a little quick setup..."

    detect_world

    touch $SEMAPHORE_PATH
}

###################################################

configure_world