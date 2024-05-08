#!/bin/bash

FUNCTION_NAME="Hetrixools"

# Function to enable maintenance mode
function enable_hetrix_maintenance_mode() {

  if [ -z "$HETRIX_API_KEY" ]; then
    log_warning $FUNCTION_NAME "There is no Hetrix API key in the .env"
  else
    log_info $FUNCTION_NAME "Try to set Hetrixtools monitor in maintenance..."
    
    RESULT=$(curl -s -X POST "https://api.hetrixtools.com/v2/$HETRIX_API_KEY/maintenance/$HETRIX_MONITOR_ID/3/" -H 'Content-Type: application/json')
    
    if [[ $RESULT == '{"status":"SUCCESS"'* ]]; then
    
      log_info $FUNCTION_NAME "Hetrixtools monitor is successfull put in maintenance"
      return 1
    fi
    
    log_error $FUNCTION_NAME "Could not set Hetrixtools monitor in maintenance"
    return 0
  fi
}

# Function to disable maintenance mode
function disable_hetrix_maintenance_mode() {

  if [ -z "$HETRIX_API_KEY" ]; then
    log_warning $FUNCTION_NAME "There is no Hetrix API key in the .env"
  else
    log_info $FUNCTION_NAME "Try to turn off maintenance in Hetrixtools monitor ..."
      
    RESULT=$(curl -s -X POST "https://api.hetrixtools.com/v2/$HETRIX_API_KEY/maintenance/$HETRIX_MONITOR_ID/1/" -H 'Content-Type: application/json')
    
    if [[ $RESULT == '{"status":"SUCCESS"'* ]]; then
    
      log_info $FUNCTION_NAME "Hetrixtools monitor is successfull out off maintenance"
      return 1
    fi

    log_error $FUNCTION_NAME "Could turn off Hetrixtools monitor maintenance"
    return 0
  fi
}
