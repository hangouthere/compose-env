#!/bin/sh

. "$(dirname $0)/_util.sh"

: <<'NOTES'



NOTES

# Source the vaildation scripts
. $SCRIPT_PATH/validate/init.sh

# Exit Check
exitVal=$?
if [ "$exitVal" -ne 0 ]; then
    echo -e "\n❌ Could not validate server files, so the server could not be started!"

    exit $exitVal
fi

# Start the script provided by itzg/docker-minecraft-server
echo -e "» Starting MC Server...\n\n---------------------------------------------------------\n\n"
/start
