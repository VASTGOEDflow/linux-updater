#!/bin/bash

FUNCTION_NAME="Updater"

# Note: When executing the update or upgrade the logs are located in: /var/log/apt
# Thats why I just throw it inside a black-hole.

# Function to update packages
function update_packages() {

  log_info $FUNCTION_NAME "Updating packages..."

  # Hmm update dont give error when there is network error and can give sometimes warnings.
  # Fetches you a list of packages for all of your repositories and PPA’s and make sure it is up to date
  apt update >/dev/null 2>&1 </dev/null >> logs/apt-update.txt

  if [ $? -eq 0 ]; then

    log_info $FUNCTION_NAME "Update successful."
    
    upgrade_dist

  else 
  
    log_error $FUNCTION_NAME "Update not working."
  fi
}

function upgrade_dist() {

    # Dist-upgrade in addition to performing the function of upgrade,
    # also intelligently handles changing dependencies with new versions
    # of packages; apt-get has a "smart" conflict resolution system, and
    # it will attempt to upgrade the most important packages at the
    # expense of less important ones if necessary. So, dist-upgrade
    # command may remove some packages.
    apt dist-upgrade -y >/dev/null 2>&1 </dev/null >> logs/apt-dist-upgrade.txt
        
    if [ $? -eq 0 ]; then

        log_info $FUNCTION_NAME "Dist upgrade successful."
       
    else 
    
        log_error $FUNCTION_NAME "Dist upgrade not working."
    fi
}

# Function to clean up packages
function clean_up() {

  log_info $FUNCTION_NAME  "Cleaning up..."

  # Autoremove is used to remove packages that were automatically installed to satisfy dependencies for other packages
  # and are now no longer needed as dependencies changed or the package(s) needing them were removed in the meantime.
  apt autoremove -y >/dev/null 2>&1 </dev/null >> logs/apt-autoremove.txt

  if [ $? -eq 0 ]; then

      log_info $FUNCTION_NAME "Autoremove successful."
      
  else 
  
      log_error $FUNCTION_NAME "Autoremove not working."
  fi

  # Autoclean clears out the local repository of retrieved package files.
  apt autoclean >/dev/null 2>&1 </dev/null >> logs/apt-autoclean.txt
  
  if [ $? -eq 0 ]; then

      log_info $FUNCTION_NAME "Autoclean successful."
      
  else 
  
      log_error $FUNCTION_NAME "Autoclean not working."
  fi
}