LOGS_DIR="logs/"
LOG_FILE="${LOGS_DIR}$(date "+%Y-%m-%d").log"

LOGGER_FUNCTION_NAME="Logger"

function log_init {

    if [ ! -d "$LOGS_DIR" ]; then
        mkdir -p "$LOGS_DIR"
        log_info "Logs directory created: $LOGS_DIR"
    fi

    if [ ! -f "$LOG_FILE" ]; then
        log_info $LOGGER_FUNCTION_NAME "Log file created: $LOG_FILE"
    else
        log_info $LOGGER_FUNCTION_NAME "Log file already exists: $LOG_FILE"
    fi
}

function log_output {

  echo `date "+%H:%M:%S"`" | $1"
  echo `date "+%H:%M:%S"`" | $1" >> $LOG_FILE
}

function log_debug {

  if [[ "$LOG_LEVEL" =~ ^(DEBUG)$ ]]; then
    log_output "🤔 DEBUG | $1 | $2"
  fi
}

function log_info {

  if [[ "$LOG_LEVEL" =~ ^(DEBUG|INFO)$ ]]; then
    log_output "ℹ️ INFO | $1 | $2"
  fi
}

function log_warn {

  if [[ "$LOG_LEVEL" =~ ^(DEBUG|INFO|WARN)$ ]]; then
    log_output "⚠️ WARN | $1 | $2"
  fi
}

function log_error {

  if [[ "$LOG_LEVEL" =~ ^(DEBUG|INFO|WARN|ERROR)$ ]]; then
    log_output "❌ ERROR | $1 | $2"
  fi

  export HAS_ERROR=true
}

function log_start {

  log_output "🚀 START | $1"
}

function log_done {

  if [[ "$HAS_ERROR" == 'true' ]]; then
    local TEXT="🏖️ END (with 1 or more errors)"
  else
    local TEXT="🏖️ END"
  fi

  log_output "$TEXT"
}

log_init
