#!/bin/bash

UPDATER_FUNCTION_NAME="Updater"

# Note: When executing apt the detailed logs are also located in: /var/log/apt
# Per-command output is captured under $APP_DIRECTORY/logs/ for the Slack zip.

function update_packages() {

  local log_file="${APP_DIRECTORY}/logs/apt-update.txt"

  log_info "$UPDATER_FUNCTION_NAME" "Updating packages..."

  apt update >> "$log_file" 2>&1 </dev/null

  # apt update does not reliably exit non-zero on network errors.
  # Scan the captured output for the error patterns apt itself emits.
  if grep -qE '^(Err:|E: |W: Failed to fetch)' "$log_file"; then

    log_error "$UPDATER_FUNCTION_NAME" "apt update reported errors (see $log_file)"
    return
  fi

  log_info "$UPDATER_FUNCTION_NAME" "Update successful."

  upgrade_dist
}

function upgrade_dist() {

  local log_file="${APP_DIRECTORY}/logs/apt-dist-upgrade.txt"

  if apt dist-upgrade -y >> "$log_file" 2>&1 </dev/null; then

    log_info "$UPDATER_FUNCTION_NAME" "Dist upgrade successful."
  else

    log_error "$UPDATER_FUNCTION_NAME" "Dist upgrade not working."
  fi
}

function clean_up() {

  local autoremove_log="${APP_DIRECTORY}/logs/apt-autoremove.txt"
  local autoclean_log="${APP_DIRECTORY}/logs/apt-autoclean.txt"

  log_info "$UPDATER_FUNCTION_NAME" "Cleaning up..."

  if apt autoremove -y >> "$autoremove_log" 2>&1 </dev/null; then

    log_info "$UPDATER_FUNCTION_NAME" "Autoremove successful."
  else

    log_error "$UPDATER_FUNCTION_NAME" "Autoremove not working."
  fi

  if apt autoclean >> "$autoclean_log" 2>&1 </dev/null; then

    log_info "$UPDATER_FUNCTION_NAME" "Autoclean successful."
  else

    log_error "$UPDATER_FUNCTION_NAME" "Autoclean not working."
  fi
}
