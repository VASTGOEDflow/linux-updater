#!/bin/bash

USERNAME=$(whoami)
UNAMEOUT="$(uname -s)"
APP_DIRECTORY=$(dirname "$(readlink -f "$0")")
MACHINE_NAME=$(hostname)
export HAS_ERROR=false

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

if [ -f "$APP_DIRECTORY/.maintenance" ]; then

    slack_message "$SLACK_CHANNEL" "Tried to execute update.sh when maintenance is already started on host \"$MACHINE_NAME\""

    log_error "Update" "The maintenance already started."
    exit 1
fi

# Starting message
log_start "Starting update script as \"$USERNAME\" on the host: \"$MACHINE_NAME\""

enable_maintenance_mode

source functions/before.sh

update_packages
clean_up

source functions/after.sh


if [[ "$HAS_ERROR" == 'true' ]]; then

  slack_message "$SLACK_CHANNEL" "❌ACTION REQUIRED❌: Updater for \"$MACHINE_NAME\" had one or more errors."

  log_done

  else

  slack_message "$SLACK_CHANNEL" "Rebooting \"$MACHINE_NAME\""
  log_info  "Rebooting \"$MACHINE_NAME\""
  log_done

  /sbin/shutdown -r now

fi
