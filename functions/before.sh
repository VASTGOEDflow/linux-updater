#!/bin/bash

BEFORE_FUNCTION_NAME="Before"

for file in "$APP_DIRECTORY"/hooks.d/before/*; do

    [ -f "$file" ] || continue

    log_info "$BEFORE_FUNCTION_NAME" "Executing before hook: $(basename "$file")"

    source "$file"
done
