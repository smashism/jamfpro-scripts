#!/bin/sh

#  warranty_info.sh
#  
#  Created by smashism on 9/28/15.
#
#  Reads from com.apple.warranty to display warranty information in a cocoaDialog
#  pop-up box via policy in Self Service
#

# Set CocoaDialog Location
CD="/Library/Application Support/JAMF/bin/cocoaDialog.app/Contents/MacOS/cocoaDialog"

#	get plist data
WarrantyDate=`/usr/bin/defaults read /Library/Preferences/com.apple.warranty WarrantyDate`
WarrantyStatus=`/usr/bin/defaults read /Library/Preferences/com.apple.warranty WarrantyStatus`

# get s/n
SerialNumber=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'`

# get computername
ComputerName=`hostname`

# Dialog to display warranty information.
/Library/Application\ Support/JAMF/bin/cocoaDialog.app/Contents/MacOS/cocoaDialog msgbox \
--title "" --text "Computer Warranty Info for $ComputerName" \
--icon "computer" \
--informative-text "Serial Number: $SerialNumber
Warranty Status: $WarrantyStatus
Expiry: $WarrantyDate
" --button1 "OK" --float --quiet
