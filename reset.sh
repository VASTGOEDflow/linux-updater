#!/bin/bash
set -uo pipefail

APP_DIRECTORY=$(dirname "$(readlink -f "$0")")
cd "$APP_DIRECTORY" || exit 1

USERNAME=$(whoami)
MACHINE_NAME=$(hostname)
HAS_ERROR=false

# Are you root?
if [[ ${UID} != 0 ]]; then

    echo "This script must be run as root or with sudo permissions. Please run using sudo."
    exit 1
fi

if [ ! -f "$APP_DIRECTORY/.env" ]; then

    echo "The .env file does not exist. Please copy .env.dist to .env."
    exit 1
fi

source "$APP_DIRECTORY/.env"

: "${LOG_LEVEL:=INFO}"
: "${HETRIX_API_KEY:=}"
: "${HETRIX_MONITOR_IDS:=}"
: "${SLACK_TOKEN:=}"
: "${SLACK_CHANNEL:=}"

source "$APP_DIRECTORY/functions/log.sh"
source "$APP_DIRECTORY/functions/updater.sh"
source "$APP_DIRECTORY/functions/slack.sh"
source "$APP_DIRECTORY/functions/maintenance.sh"
source "$APP_DIRECTORY/functions/hetrixtools.sh"

if [ ! -f "$APP_DIRECTORY/.maintenance" ]; then

    # Normal boot that wasn't preceded by an update-triggered reboot.
    # Nothing to reset — exit quietly without alerting Slack.
    log_info "Update" "No .maintenance flag present, nothing to reset"
    exit 0
fi

# Starting message
log_start "Reset update script as \"$USERNAME\" on the host: \"$MACHINE_NAME\""

# Wait for network and other is up..
for i in {1..10}; do

  log_info "Update" "Checking network (attempt $i)..."

  if ping -c 1 -W 2 8.8.8.8 1>/dev/null 2>&1; then

    log_info "Update" "Network available (attempts: $i), waiting 90s for HetrixTools agent to report in..."

    sleep 90

    log_info "Update" "Disabling maintenance"

    disable_maintenance_mode

    exit 0
  fi

  log_error "Update" "No network (attempt $i), waiting 10 seconds..."

  sleep 10
done

log_error "Update" "No network, aborting after 10 attempts"

exit 1
