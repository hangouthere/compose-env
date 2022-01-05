#!/bin/sh

. "$(dirname $0)/util.sh"

echo "Searching: $COMPOSE_FILE_PATH"

composeFiles=`find $COMPOSE_FILE_PATH -maxdepth 1 -name "docker-compose*.yml"`
composeFiles=`echo $composeFiles | sed -e "s#$COMPOSE_FILE_PATH/docker-compose\.##g" | sed -e "s#\.yml##g" | sed -e "s# #\n#g"`
numFiles=`echo "$composeFiles" | wc -l`

help=$(cat <<endHelp
> Found $numFiles Compose Environments:

$composeFiles

> Available Commands:
    ddn <envName> - Take an Environment Down
    dup <envName> - Bring an Environment Up
    dpull <envName> - Pull new Images for an Environment
    dupdate <envName> - Performs a pull, down, and up on an Environment

> Example Usage:
    dpull web
    dupdate game-servers

endHelp
)

echo "$help"