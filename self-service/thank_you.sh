#!/bin/bash

# This script displays a message that thanks the person 
# on the other end of the screen for sending in information
# to IT.  
# Gratitude attitude!
# by smashism, same bat-time, same bat-channel
#

# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

dialog="Thank you for updating your computer information with Corporate IT! If you need further assistance please send in a Help Desk ticket."
description=`echo "$dialog"`
button1="OK"
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
icon="/Applications/Company\ Self\ Service.app/Contents/Resources/Self\ Service.icns"

if [[ ${osvers} -lt 7 ]]; then

  "$jamfHelper" -windowType utility -description "$description" -button1 "$button1" -icon "$icon"

fi

if [[ ${osvers} -ge 7 ]]; then

  jamf displayMessage -message "$dialog"

fi

exit 0
