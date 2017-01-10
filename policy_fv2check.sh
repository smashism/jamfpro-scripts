#!/bin/bash

###
#
#            Name:  policy_fv2check.sh
#     Description:  This script checks the fdesetup status of the machine, then displays either:
#                   1- the FileVault 2 status in a dialog
#                   2- runs custom trigger to enable FV2, and displays dialogs from that policy
#          Author:  Dr. Emily Kausalik (drkausalik@gmail.com)
#         Created:  2017-01-09
#   Last Modified:  2017-01-10
#
###

################################## VARIABLES ##################################
dialogTitle="Company Disk Encryption"
LOGO_ICNS="/path/to/CompanyLogo.icns" # update this with whatever logo you want to use
LOGO_ICNS="$(osascript -e 'tell application "System Events" to return POSIX file "'"$LOGO_ICNS"'" as text')"

################################## FV2 CHECK ##################################

FV_STATUS="$(fdesetup status | awk "NR==1{print;exit}")"
if grep -q "Encryption in progress" <<< "$FV_STATUS"; then
	echo "The encryption process is still in progress."
	echo "$FV_STATUS"
	/usr/bin/osascript -e 'display dialog "Encryption Status: '"${FV_STATUS//\"/\\\"}"'

If you have any questions or need additional assistance please email helpdesk@rmn.com." buttons {"OK"} default button 1 with title "'"${dialogTitle//\"/\\\"}"'" giving up after 60 with icon file "'"${LOGO_ICNS//\"/\\\"}"'"'
elif grep -q "FileVault is Off" <<< "$FV_STATUS"; then
	echo "Encryption is not active."
	echo "$FV_STATUS"
	/bin/echo "Enforcing framework, then running FileVault 2 policy trigger."
	/usr/bin/sudo /usr/local/bin/jamf manage
	/usr/bin/sudo /usr/local/bin/jamf policy -event fv2_trigger # change trigger to whatever you are using in your JSS 
	/usr/bin/osascript -e 'display dialog "Thank you for enabling FileVault 2 on your Company Mac.

We are now updating your computer info. Please restart at your earliest convenience." buttons {"OK"} default button 1 with title "'"${dialogTitle//\"/\\\"}"'" giving up after 60 with icon file "'"${LOGO_ICNS//\"/\\\"}"'"'
elif grep -q "FileVault is On" <<< "$FV_STATUS"; then
	echo "This machine is already encrypted."
	echo "$FV_STATUS"
	/usr/bin/osascript -e 'display dialog "Encryption Status: '"${FV_STATUS//\"/\\\"}"'

If you have any questions or need additional assistance please email helpdesk@company.com." buttons {"OK"} default button 1 with title "'"${dialogTitle//\"/\\\"}"'" giving up after 60 with icon file "'"${LOGO_ICNS//\"/\\\"}"'"'
elif ! grep -q "FileVault is On" <<< "$FV_STATUS"; then
	echo "Unable to determine encryption status."
	echo "$FV_STATUS"
	/usr/bin/osascript -e 'display dialog "Encryption Status: '"${FV_STATUS//\"/\\\"}"'. 

Email helpdesk@company.com for assistance." buttons {"OK"} default button 1 with title "'"${dialogTitle//\"/\\\"}"'" giving up after 60 with icon file "'"${LOGO_ICNS//\"/\\\"}"'"'
fi
