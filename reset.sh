#!/bin/bash

USERNAME=$(whoami)
UNAMEOUT="$(uname -s)"
APP_DIRECTORY=$(dirname "$(readlink -f "$0")")
MACHINE_NAME=$(hostname)

# Are you root?
if [[ ${UID} != 0 ]]; then

    echo "This script must be run as root or with sudo permissions. Please run using sudo."
    exit 1
fi

if [ ! -f .env ]; then

    echo "The .env file does not exists. Please copy .env.dist to .env."
    exit 1
fi

# Load functions and env
source .env
source functions/log.sh
source functions/updater.sh
source functions/slack.sh
source functions/maintenance.sh
source functions/hetrixtools.sh

if [ ! -f $APP_DIRECTORY"/.maintenance" ]; then

    slack_message $SLACK_CHANNEL "Tried to execute reset.sh when maintenance is not started on host \"$MACHINE_NAME\""

    log_error "Update" "The maintenance is not started."
    exit 1
fi

# Starting message
log_start "Reset update script as \"$USERNAME\" on the host: \"$MACHINE_NAME\""

# Wait for network and other is up.. Maybe make real network check?
sleep 90

disable_maintenance_mode
