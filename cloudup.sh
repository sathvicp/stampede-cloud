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

echo "Checks passed successfully."
echo "."
echo "Deploying nextcloud stack..."

# Deploy docker stack
if docker stack deploy --compose-file=$FILE nextcloud &> /dev/null
then
    # On successfull stack deployment
    echo "Stack deployed successfully. Starting cron service for nextcloud_app container"
    if docker exec -d nextcloud_app.1.$(docker service ps -f 'name=nextcloud_app.1' nextcloud_app -q --no-trunc | head -n1) sh -c "/cron.sh" &> /dev/null
    then
	echo "."
	echo "Cron service started successfully."
    else
	echoerr "[ERROR] Cron service could not be started successfully"
	exit 5
    fi
else
    echoerr "[ERROR] Could not start the docker stack"
    exit 4
fi

echo "."
echo "Cloud deployed successfully."
exit

