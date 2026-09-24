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

# Defaults for optional values so set -u doesn't trip
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

MAINTENANCE_FLAG="$APP_DIRECTORY/.maintenance"
MAINTENANCE_STALE_AFTER=21600  # 6 hours

if [ -f "$MAINTENANCE_FLAG" ]; then

    maint_age=$(($(date +%s) - $(stat -c %Y "$MAINTENANCE_FLAG")))

    if [ "$maint_age" -lt "$MAINTENANCE_STALE_AFTER" ]; then

        slack_message "$SLACK_CHANNEL" "Tried to execute update.sh when maintenance is already started on host \"$MACHINE_NAME\""

        log_error "Update" "The maintenance already started."
        exit 1
    fi

    log_warn "Update" "Stale .maintenance flag (age ${maint_age}s), continuing"
    rm -f "$MAINTENANCE_FLAG"
fi

# Starting message
log_start "Starting update script as \"$USERNAME\" on the host: \"$MACHINE_NAME\""

enable_maintenance_mode

source "$APP_DIRECTORY/functions/before.sh"

update_packages
clean_up

source "$APP_DIRECTORY/functions/after.sh"


if [[ "$HAS_ERROR" == 'true' ]]; then

  slack_message "$SLACK_CHANNEL" "❌ACTION REQUIRED❌: Updater for \"$MACHINE_NAME\" had one or more errors."

  log_done
  exit 0
fi

log_done

if [ -f /var/run/reboot-required ]; then

  slack_message "$SLACK_CHANNEL" "Rebooting \"$MACHINE_NAME\""
  log_info "Updater" "Rebooting \"$MACHINE_NAME\""

  /sbin/shutdown -r now
else

  log_info "Updater" "No reboot required, disabling maintenance"

  disable_maintenance_mode
fi
