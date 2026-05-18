#!/bin/bash

AFTER_FUNCTION_NAME="After"

for file in "$APP_DIRECTORY"/hooks.d/after/*; do

    [ -f "$file" ] || continue

    log_info "$AFTER_FUNCTION_NAME" "Executing after hook: $(basename "$file")"

    source "$file"
done
