#!/bin/bash

UPDATER_FUNCTION_NAME="Before"

for file in $(ls -v $APP_DIRECTORY"/hooks.d/before"); do

    if [ -f $APP_DIRECTORY"/hooks.d/before/"$file ]; then

        log_info $UPDATER_FUNCTION_NAME "Executing before hook: $file"

        source $APP_DIRECTORY"/hooks.d/before/"$file
    fi
done