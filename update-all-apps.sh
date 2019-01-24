#!/bin/bash
###
#
#            Name:  update-all-apps.sh
#     Description:  Cycles through all third party updates in Jamf and runs them if
#                   needed by the target Mac.
#          Author:  Emily KW
#        Modified:  2019-01-23
#           Notes:  Results/output sent to /var/log/jamf.log.
#                   Does not include patch policies. The final recon, however, will by 
#                   default check for patch policies, but will not run them automatically
#                   unless you configure patch policies to install automatically.
#
#                   Usage:
#                   - Set any update policy in your Jamf Pro Server with a custom trigger
#                   - Add all custom triggers on separate lines to the APPUPDATE section
#                   - Add this script to a policy with its own custom trigger and/or
#                     make available in its own Self Service policy for people to use
#
#                   Room for improvement:
#                   - Close each app if the update is required.
#
###

jamf=$(which jamf)
jamfLog="/var/log/jamf.log"
# currentUser=$( python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");' )
timestamp ()  { date "+%Y-%m-%d %H:%M:%S" ; }

echo "$(timestamp) Checking for third party app updates..." | tee -a "$jamfLog"

APPUPDATE="
updateAtom
updateGitHubDesktop
updateOffice
updateSlack
updateVSCode
"

for TRIGGER in $APPUPDATE
do
    echo "$(timestamp) Checking for update policy $TRIGGER" | tee -a "$jamfLog"
    "$jamf" policy -event $TRIGGER -forceNoRecon -randomDelaySeconds 0 | tee -a "$jamfLog"
done

echo "$(timestamp) Submitting updated inventory..." | tee -a "$jamfLog"
"$jamf" recon -randomdelayseconds 0

echo "$(timestamp) All available managed third party updates installed." | tee -a "$jamfLog"

exit 0
