#!/bin/bash

###
#
#            Name:  nomad_update.sh
#     Description:  This script checks that NoMAD.app is installed, then does the following:
#                   1- Checks for OS version to run correct launchctl method.
#                   2- Unloads the NoMAD LaunchAgent in the user context.
#                   3- Runs a .pkg installer of the new NoMAD version on secondary/helper policy 
#                      with custom trigger 'update_nomad'.
#                   4- Loads the NoMAD LaunchAgent in the user context to relaunch app.
#            Note:  Largely cobbled together from Elliot Jordan's scripts and jamfnation posts.
#          Author:  Emily Kausalik (drkausalik@gmail.com)
#         Created:  2016-12-12
#   Last Modified:  2016-12-12
#
###

# Make sure app exists.
echo "Making sure NoMAD is installed..."
if [[ ! -d "/Applications/NoMAD.app" ]]; then
    echo "[ERROR] /Applications/NoMAD.app does not exist."
    exit 1002
fi

# Get current user and OS information.
CURRENT_USER=$(/usr/bin/stat -f%Su /dev/console)
USER_ID=$(id -u "$CURRENT_USER")
OS_MAJOR=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}')
OS_MINOR=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $2}')

# Closing NoMAD using launchctl.
echo "Closing NoMAD..."
if [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -le 9 ]]; then
    LOGINWINDOW_PID=$(pgrep -x -u "$USER_ID" loginwindow)
    /bin/launchctl bsexec "$LOGINWINDOW_PID" /bin/launchctl unload /Users/"$CURRENT_USER"/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
elif [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -gt 9 ]]; then
    /bin/launchctl asuser "$USER_ID" /bin/launchctl unload /Users/"$CURRENT_USER"/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
else
    echo "[ERROR] macOS $OS_MAJOR.$OS_MINOR is not supported."
    exit 1004
fi

# Making sure application is closed
osascript -e "tell application \"NoMAD\" to quit" # potentially redundant, but meant to prevent duplicate processes from running

# Installing newest version of NoMAD
echo "Installing newest version of NoMAD..."
jamf policy -trigger update_nomad # change this to whatever custom trigger you use for the installer policy

# Launching NoMAD using launchctl.
echo "Launching NoMAD..."
if [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -le 9 ]]; then
    LOGINWINDOW_PID=$(pgrep -x -u "$USER_ID" loginwindow)
    /bin/launchctl bsexec "$LOGINWINDOW_PID" /bin/launchctl load /Users/"$CURRENT_USER"/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
elif [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -gt 9 ]]; then
    /bin/launchctl asuser "$USER_ID" /bin/launchctl load /Users/"$CURRENT_USER"/Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
else
    echo "[ERROR] macOS $OS_MAJOR.$OS_MINOR is not supported."
    exit 1004
fi

exit 0
