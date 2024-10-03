#!/bin/bash

HETRIXTOOLS_FUNCTION_NAME="Hetrixools"

# Function to enable maintenance mode
function enable_hetrix_maintenance_mode() {

  if [ -z "$HETRIX_API_KEY" ]; then
    log_warning $HETRIXTOOLS_FUNCTION_NAME "There is no Hetrix API key in the .env"
  else
    log_info $HETRIXTOOLS_FUNCTION_NAME "Try to set Hetrixtools monitor in maintenance..."

    IFS=',' read -r -a HETRIX_MONITOR_IDS <<<"$HETRIX_MONITOR_IDS"

    for monitor_id in "${HETRIX_MONITOR_IDS[@]}"; do
      RESULT=$(curl -s -X POST "https://api.hetrixtools.com/v2/$HETRIX_API_KEY/maintenance/$monitor_id/3/" -H 'Content-Type: application/json')

      if [[ $RESULT == '{"status":"SUCCESS"'* ]]; then
        log_info $HETRIXTOOLS_FUNCTION_NAME "Hetrixtools monitor is successfull put in maintenance"
      else
        log_error $HETRIXTOOLS_FUNCTION_NAME "Could not set Hetrixtools monitor in maintenance"
      fi
    done

    return 0
  fi
}

# Function to disable maintenance mode
function disable_hetrix_maintenance_mode() {

  if [ -z "$HETRIX_API_KEY" ]; then
    log_warning $HETRIXTOOLS_FUNCTION_NAME "There is no Hetrix API key in the .env"
  else
    log_info $HETRIXTOOLS_FUNCTION_NAME "Try to turn off maintenance in Hetrixtools monitor ..."

    IFS=',' read -r -a HETRIX_MONITOR_IDS <<<"$HETRIX_MONITOR_IDS"

    for monitor_id in "${HETRIX_MONITOR_IDS[@]}"; do
      RESULT=$(curl -s -X POST "https://api.hetrixtools.com/v2/$HETRIX_API_KEY/maintenance/$monitor_id/1/" -H 'Content-Type: application/json')

      if [[ $RESULT == '{"status":"SUCCESS"'* ]]; then
        log_info $HETRIXTOOLS_FUNCTION_NAME "Hetrixtools monitor is successfull put in maintenance"
      else
        log_error $HETRIXTOOLS_FUNCTION_NAME "Could not set Hetrixtools monitor in maintenance"
      fi
    done

    return 0
  fi
}
