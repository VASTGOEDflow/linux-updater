#!/bin/bash

HETRIXTOOLS_FUNCTION_NAME="Hetrixtools"

function enable_hetrix_maintenance_mode() {

  if [ -z "${HETRIX_API_KEY:-}" ]; then

    log_warn "$HETRIXTOOLS_FUNCTION_NAME" "There is no Hetrix API key in the .env"
    return
  fi

  log_info "$HETRIXTOOLS_FUNCTION_NAME" "Try to set Hetrixtools monitor in maintenance..."

  local -a ids
  IFS=',' read -r -a ids <<< "$HETRIX_MONITOR_IDS"

  local monitor_id result
  for monitor_id in "${ids[@]}"; do

    result=$(curl -s -X POST "https://api.hetrixtools.com/v2/${HETRIX_API_KEY}/maintenance/${monitor_id}/3/" -H 'Content-Type: application/json')

    if [[ "$result" == '{"status":"SUCCESS"'* ]]; then

      log_info "$HETRIXTOOLS_FUNCTION_NAME" "Monitor ${monitor_id} put in maintenance"
    else

      log_error "$HETRIXTOOLS_FUNCTION_NAME" "Could not set monitor ${monitor_id} in maintenance: $result"
    fi
  done
}

function disable_hetrix_maintenance_mode() {

  if [ -z "${HETRIX_API_KEY:-}" ]; then

    log_warn "$HETRIXTOOLS_FUNCTION_NAME" "There is no Hetrix API key in the .env"
    return
  fi

  log_info "$HETRIXTOOLS_FUNCTION_NAME" "Try to remove Hetrixtools monitor from maintenance..."

  local -a ids
  IFS=',' read -r -a ids <<< "$HETRIX_MONITOR_IDS"

  local monitor_id result
  for monitor_id in "${ids[@]}"; do

    result=$(curl -s -X POST "https://api.hetrixtools.com/v2/${HETRIX_API_KEY}/maintenance/${monitor_id}/1/" -H 'Content-Type: application/json')

    if [[ "$result" == '{"status":"SUCCESS"'* ]]; then

      log_info "$HETRIXTOOLS_FUNCTION_NAME" "Monitor ${monitor_id} removed from maintenance"
    else

      log_error "$HETRIXTOOLS_FUNCTION_NAME" "Could not remove monitor ${monitor_id} from maintenance: $result"
    fi
  done
}
