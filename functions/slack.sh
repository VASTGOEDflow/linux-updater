#!/bin/bash

SLACK_FUNCTION_NAME="Slack"

slack_message() {

  if [[ -z "${1:-}" || -z "${2:-}" ]]; then

    echo "Please provide a channel and a message" >&2
    return 1
  fi

  if [[ -z "${SLACK_TOKEN:-}" ]]; then

    log_warn "$SLACK_FUNCTION_NAME" "No SLACK_TOKEN in .env, skipping Slack message"
    return 0
  fi

  local channel="$1"
  local text="$2"
  local result

  result=$(curl -s \
    --data-urlencode "text=${text}" \
    --data-urlencode "channel=${channel}" \
    -H "Authorization: Bearer ${SLACK_TOKEN}" \
    -X POST https://slack.com/api/chat.postMessage)

  log_debug "$SLACK_FUNCTION_NAME" "$result"

  if [[ "$result" == '{"ok":true'* ]]; then

    log_info "$SLACK_FUNCTION_NAME" "Sent message to Slack"
    return 0
  fi

  log_error "$SLACK_FUNCTION_NAME" "Sending message to Slack failed: $result"
  return 1
}
