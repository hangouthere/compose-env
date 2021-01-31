#!/bin/sh

. "$(dirname $0)/_util.sh"

# Checks if the world actually exists, and has a "live" backup
verify_backups_exist() {
    verify_server_exists

    # Verify the live backup for the world path exists
    if [ ! -d $BACKUP_LIVE_PATH ]; then
        echo "☠ Live Backup for \"$WORLD_NAME\" does not exist."
        exit 98
    fi
}

ensure_world_setup_complete() {
    sh $SCRIPT_PATH/setup_mc_world.sh $WORLD_NAME
}

verify_backups_exist
ensure_world_setup_complete
docker-compose -f $ROOT_PATH/docker-compose.mc.yml up -d
