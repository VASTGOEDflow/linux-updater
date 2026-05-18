#!/bin/bash

MAINTENANCE_FUNCTION_NAME="Maintenance"

function enable_maintenance_mode() {

  enable_hetrix_maintenance_mode

  slack_message "$SLACK_CHANNEL" "Starting maintenance on the host \"$MACHINE_NAME\""

  touch "$APP_DIRECTORY/.maintenance"
}

function disable_maintenance_mode() {

  disable_hetrix_maintenance_mode

  slack_message "$SLACK_CHANNEL" "Stopping maintenance on the host \"$MACHINE_NAME\""

  rm -f "$APP_DIRECTORY/.maintenance"

  if [ -d "${APP_DIRECTORY}/logs" ]; then

    rm -rf "${APP_DIRECTORY}/logs"
  fi
}
