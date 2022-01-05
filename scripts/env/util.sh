COMPOSE_FILE_PATH_RAW=~/Storage/compose

COMPOSE_FILE_PATH="$(dirname $COMPOSE_FILE_PATH_RAW)/$(basename $COMPOSE_FILE_PATH_RAW)"

getComposeFilePath() {
    local _outval=$1
    local envName=$2
    local filePath=$COMPOSE_FILE_PATH/docker-compose.$envName.yml

    eval "$_outval=\$filePath"
}

checkComposeFile() {
    if [ ! -f $composeFile ]; then
        echo "Error: Compose file does not exist - $1"
        exit 99
    fi
}

composeOperation() {
    local envName=$1
    local operation=$2
    local composeFile

    if [ "up" = "$operation" ]; then
        operation="up -d"
    fi

    getComposeFilePath composeFile $envName
    checkComposeFile $composeFile

    docker-compose -f $composeFile $operation
}
