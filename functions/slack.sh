#!/bin/bash

SLACK_FUNCTION_NAME="Slack"

slack_message() {

  if [[ -z "$1" || -z "$2" ]]; then
    echo "Please provide a channel and a message"
    exit 1
  fi

  local FILE=$APP_DIRECTORY"/logs.zip"

  local TEXT=${2}

  log_debug $SLACK_FUNCTION_NAME $FILE

  if [ -f $FILE ]; then

    log_debug $SLACK_FUNCTION_NAME "curl -s -F "file=@${FILE}" -F "filetype=zip" -F "filename=$(basename ${FILE})" -F "initial_comment=Bijlage" -F "channels=${1}" -H "Authorization: Bearer ${SLACK_TOKEN}" https://slack.com/api/files.upload"

    RESULT=$(curl -s -F "file=@${FILE}" -F "filetype=zip" -F "filename=$(basename "${FILE}")" -F "initial_comment=${TEXT}" -F "channels=${1}" -H "Authorization: Bearer ${SLACK_TOKEN}" https://slack.com/api/files.upload)

  else

    RESULT=$(curl -s -d "text=${TEXT}" -d "channel=${1}" -H "Authorization: Bearer ${SLACK_TOKEN}" -X POST https://slack.com/api/chat.postMessage)
  fi

  log_debug $SLACK_FUNCTION_NAME $RESULT

  if [[ $RESULT == '{"ok":true'* ]]; then
    log_info $SLACK_FUNCTION_NAME "Send message to Slack ..."
    return 1
  fi

  log_error $SLACK_FUNCTION_NAME "Sending message to Slack failed..."
  return 0
}