#!/bin/bash

###
#
#            Name:  smarty_receipt_maker.sh
#     Description:  This script generates a receipt in plist format by taking
#                   variables passed in a Jamf policy script settings pane. This
#                   information can then be used for EAs and other reporting.
#                   - plistName ($4): the name of the plist
#                   - plistPath ($5): where to store the plist on the Mac
#                   - nameString ($6): what you want the Key of Name to be set to
#                   - currentDate: gets the current date in a format Jamf can use
#                     for a date-based EA
#            Note:  Jamf will write the plist with root priviledges, and will also read
#                   with root priviledges when running an EA check during recon. To read
#                   the plist locally (in terminal) use sudo. See line 34 for optional
#                   commands to adjust permissions for easier reading.
#          Author:  Emily Kausalik
#         Created:  2016-12-30
#   Last Modified:  2018-09-04
#
###

plistName="$4" # Name of the plist file (e.g., com.planetexpress.expendable.plist)
plistPath="$5" # Path to plist file (e.g., /Users/Shared/Careerchips)
nameString="$6" # What to put in a name string

currentDate=$(date +"%Y-%m-%d %H:%M:%S") # Creates date in format Jamf can use for date-based data type EA

/bin/echo "Writing $nameString to $plistPath/$plistName"
/usr/bin/defaults write $plistPath/$plistName Name "$nameString" # Double-duty: will make plist if doesn't exist, then write the value!
/bin/echo "Writing $currentDate to $plistPath/$plistName"
/usr/bin/defaults write $plistPath/$plistName Date "$currentDate" # Date can be used in Jamf EA with "Date" data type.

# Optional: remove comment-out on the next two lines to make the plist more reasily readable by non-root users
#/bin/echo "Making $plistName readible to non-root users"
#/bin/chmod 744 $plistPath/$plistName

# Dosvedanya, comrade!

exit 0
