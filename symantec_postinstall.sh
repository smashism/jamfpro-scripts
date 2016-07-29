#!/bin/sh
## postinstall
##
## Prompts user for restart time (now, 1 minute, 3 minutes, 5 minutes)
## then runs SymantecRemovalTool.command from pathToPackage (/private/tmp)
## once complete, reboots machine and completes uninstall.
## Designed to use with Composer (see notes below).
## 
## Cobbled together from scripts shared on jamfnation and guide from Symantec
## https://support.symantec.com/en_US/article.TECH103489.html
##
## Created: 2016-07-29 by github.com/smashism
## Last Modified: 2016-07-29

# Variables used by Composer (note pathToPackage used below)

pathToScript=$0
pathToPackage=$1
targetLocation=$2
targetVolume=$3

# Prompt for restart

selection=$("/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType utility -description "This process requires a restart. Please select time to restart your Mac." -button2 "Restart"  -showDelayOptions "0, 60, 180, 300" -button1 "Cancel" -cancelButton 1)

buttonClicked="${selection:$i-1}"
timeChosen="${selection%?}"

## Convert seconds to minutes for restart command
timeMinutes=$((timeChosen/60))

## Echoes for troubleshooting purposes
echo "Button clicked was: $buttonClicked"
echo "Time chosen was: $timeChosen"
echo "Time in minutes: $timeMinutes"

# Run the removal tool

$1/SymantecRemovalTool.command -A &
RemovalPID=`echo "$!"`
wait $RemovalPID
if [[ "$buttonClicked" == "2" ]] && [[ ! -z "$timeChosen" ]]; then
    echo "Restart button was clicked. Initiating restart in $timeMinutes minutes"
    shutdown -r +"$timeMinutes"
elif [[ "$buttonClicked" == "2" ]] && [[ -z "$timeChosen" ]]; then
    echo "Restart button was clicked. Initiating immediate restart"
    shutdown -r now
elif [ "$buttonClicked" == "1" ]; then
    echo "Cancel button clicked. Exiting..."
    exit 0
fi

/usr/local/bin/jamf displayMessage -message "REMINDER: This machine will reboot in $timeMinutes minutes. Please save your work and close any open applications."

exit 0		## Success
exit 1		## Failure
