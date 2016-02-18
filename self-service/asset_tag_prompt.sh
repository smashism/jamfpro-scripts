#!/bin/sh

#
# prompts user for company asset tag for inventory
# adapted by smashism
# 2014-10-03
#

# Set CocoaDialog Location
CD="/Library/Application Support/JAMF/bin/cocoaDialog.app/Contents/MacOS/cocoaDialog"

# Dialog to enter the computer name and the create $ASSETTAG variable
rv=($("$CD" standard-inputbox --title "Company Asset Tag" --no-newline --informative-text "Enter the Company Asset Tag" --value-required))
ASSETTAG=${rv[1]}


# Set Hostname using variable created above
jamf recon -assetTag $ASSETTAG


# Dialog to confirm that the hostname was changed and what it was changed to.
tb=`"$CD" ok-msgbox --text "Company Asset Tag Added!" \
--informative-text "The computer's Company asset tag has been added to $ASSETTAG." \
--no-newline --float`
if [ "$tb" == "1" ]; then
echo "User said OK"
elif [ "$tb" == "2" ]; then
echo "Canceling"
exit
fi
