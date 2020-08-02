#!/bin/sh
set -eu

function echoerr() { printf "%s\n" "$*" >&2; }

cd "$(dirname "$0")"

# Check whether docker is installed
echo "Performing checks..."
if ! command -v docker &> /dev/null
then
    echoerr "[ERROR] Docker is not installed"
    exit 1
fi

# Check whether nextcloud stach is already up
if docker stack ps nextcloud &> /dev/null
then
    echoerr "[ERROR] Nextcloud is already up and running"
    exit 2
fi

# Check whether docker compose file is present or not
FILE=./docker-compose.yml
if ! test -f "$FILE"
then
    echoerr "[ERROR] File docker-compose.yml is missing"
    exit 3
fi

# Deploy docker stack
if docker stack deploy --compose-file=$FILE nextcloud
then
    # On successfull stack deployment
    NEXTCLOUD_SERVICE_ID=$(docker stack services -f name=nextcloud_app --format "{{.ID}}" nextcloud)
    docker exec -d $NEXTCLOUD_SERVICE_ID sh -c "/cron.sh"
else
    echoerr "[ERROR] Could not start the docker stack"
    exit 4
fi

echo "Stack deployed successfully"
exit

