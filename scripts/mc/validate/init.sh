#!/bin/sh

. "$(dirname $0)/_util.sh"

#######################################
# Setup MC World Backup Stuffs
#######################################

: <<'NOTES'

- If NO SEMAPHORE, so we assume setup not complete:
    - Run validate/unconfigured.sh
- If SEMAPHORE FOUND, assume setup has taken place, but we add error checks:
    - Run validate/configured.sh

NOTES

init_validation() {
    echo "» Verifying World State..."

    # If we don't have a semaphore, assume this is the very first time launching
    if [ ! -f "$SEMAPHORE_PATH" ]; then
        . $SCRIPT_PATH/validate/unconfigured.sh
    else
        # We've been set up! We can do more tests...
        . $SCRIPT_PATH/validate/configured.sh
    fi
}

init_validation