#!/bin/bash

###
#
#            Name:  assign_this_mac.sh
#     Description:  This script prompts a user to enter the LDAP account of the person
#                   the Mac should be assigned to. It uses a combination of jamfHelper
#                   and osascript for alerts and prompts.
#          Author:  Emily Kausalik
#         Created:  2017-09-06
#   Last Modified:  2017-09-06
#
###

################################## VARIABLES ##################################

# Your company's logo, in PNG format. (For use in jamfHelper messages.)
# Use standard UNIX path format:  /path/to/file.png
LOGO_PNG="/path/to/logo.png"

# Your company's logo, in ICNS format. (For use in AppleScript messages.)
# Use standard UNIX path format:  /path/to/file.icns
LOGO_ICNS="/path/to/logo.icns"

# The title of the message that will be displayed to the user.
# Not too long, or it'll get clipped.
PROMPT_TITLE="Assign Computer"

# The body of the message that will be displayed before prompting the user for
# their password. All message strings below can be multiple lines.
PROMPT_MESSAGE="We will now assign this Mac to a user account. Please use your LDAP to assign to yourself.

Click the Next button below, then enter your LDAP account when prompted."

######################## VALIDATION AND ERROR CHECKING ########################

# Suppress errors for the duration of this script. (This prevents JAMF Pro from
# marking a policy as "failed" if the words "fail" or "error" inadvertently
# appear in the script output.)
exec 2>/dev/null

BAIL=false

# Make sure the custom logos have been received successfully
if [[ ! -f "$LOGO_ICNS" ]]; then
    echo "[ERROR] Custom logo icon not present: $LOGO_ICNS"
    BAIL=true
fi
if [[ ! -f "$LOGO_PNG" ]]; then
    echo "[ERROR] Custom logo PNG not present: $LOGO_PNG"
    BAIL=true
fi

# Convert POSIX path of logo icon to Mac path for AppleScript
LOGO_ICNS="$(osascript -e 'tell application "System Events" to return POSIX file "'"$LOGO_ICNS"'" as text')"

# Bail out if jamfHelper doesn't exist.
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
if [[ ! -x "$jamfHelper" ]]; then
    echo "[ERROR] jamfHelper not found."
    BAIL=true
fi

# Check the OS version.
OS_MAJOR=$(sw_vers -productVersion | awk -F . '{print $1}')
OS_MINOR=$(sw_vers -productVersion | awk -F . '{print $2}')
if [[ "$OS_MAJOR" -ne 10 || "$OS_MINOR" -lt 9 ]]; then
    echo "[ERROR] OS version not 10.9+ or OS version unrecognized."
    sw_vers -productVersion
    BAIL=true
fi

# Get the logged in user's name
CURRENT_USER="$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"

# Get the location of the jamf binary
jamf=$(which jamf)

################################ MAIN PROCESS #################################

# Get information necessary to display messages in the current user's context.
USER_ID=$(id -u "$CURRENT_USER")
if [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -le 9 ]]; then
    L_ID=$(pgrep -x -u "$USER_ID" loginwindow)
    L_METHOD="bsexec"
elif [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -gt 9 ]]; then
    L_ID=USER_ID
    L_METHOD="asuser"
fi

# Display a branded prompt explaining the upcoming prompt.
echo "Alerting user $CURRENT_USER about incoming LDAP account prompt..."
launchctl "$L_METHOD" "$L_ID" "$jamfHelper" -windowType "hud" -icon "$LOGO_PNG" -title "$PROMPT_TITLE" -description "$PROMPT_MESSAGE" -button1 "Next" -defaultButton 1 -startlaunchd &>/dev/null

# Get the LDAP account for assignment via a prompt.
echo "Prompting $CURRENT_USER for a Mac LDAP account..."
USER_LDAP="$(launchctl "$L_METHOD" "$L_ID" osascript -e 'display dialog "Please enter the LDAP account for whom to assign this Mac:" default answer "" with title "'"${PROMPT_TITLE//\"/\\\"}"'" giving up after 86400 with text buttons {"OK"} default button 1 with icon file "'"${LOGO_ICNS//\"/\\\"}"'"' -e 'return text returned of result')"

# Run recon to assign user on computer record in jamf
"$jamf" recon -endUsername "$USER_LDAP"

echo "Displaying \"success\" message..."
launchctl "$L_METHOD" "$L_ID" "$jamfHelper" -windowType "hud" -icon "$LOGO_PNG" -title "$PROMPT_TITLE" -description "Thank you! This computer is now assigned to $USER_LDAP." -button1 'OK' -defaultButton 1 -timeout 30 -startlaunchd &>/dev/null &

exit 0
