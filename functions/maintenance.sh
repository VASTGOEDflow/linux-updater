#!/bin/bash

MAINTENANCE_FUNCTION_NAME="Maintenance"

# Function to enable maintenance mode
function enable_maintenance_mode() {

  enable_hetrix_maintenance_mode

  slack_message $SLACK_CHANNEL "Starting maintenance on the host \"$MACHINE_NAME\""

  touch $APP_DIRECTORY"/.maintenance"
}

# Function to disable maintenance mode
function disable_maintenance_mode() {

  disable_hetrix_maintenance_mode

  if ! command -v zip &> /dev/null; then
      log_error $FUNCTION_NAME "Please install zip first (apt install zip)..."
      exit 1
  else
    zip -rj $APP_DIRECTORY"/logs.zip" $APP_DIRECTORY"/logs" >/dev/null 2>&1 </dev/null >> logs/zip.txt
  fi

  slack_message $SLACK_CHANNEL "Stopping maintenance on the host \"$MACHINE_NAME\""

  rm $APP_DIRECTORY"/.maintenance"
  rm -r $APP_DIRECTORY"/logs"
  rm $APP_DIRECTORY"/logs.zip"
}
