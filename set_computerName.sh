#!/bin/sh

###
#
#            Name:  set_computerName.sh
#     Description:  This script is designed to set a computer name during DEP enrollment as follows:
#                   1- Get logged-in username
#                   2- Format the computer name as $username-mac
#                   3- Set computer name/hostname/local hostname and NetBIOSName using formatted name
#                   4- To be overly thorough, use jamf setcomputername to set name as well
#            Note:  Works best for 1x1 laptop deployments where only one person typically signs into the laptop. 
#          Author:  Emily Kausalik (drkausalik@gmail.com)
#         Created:  2017-05-30
#   Last Modified:  2017-05-30
#
#         Version:  1.0
#                   - Initial commit
#
###

# Checking jamf location
jamf=$(which jamf)

# Getting the logged-in user
loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

# Formatting computer name
computerName=$loggedInUser'-mac'

# Setting computername
echo "Setting computer name to $computerName locally..."
scutil --set ComputerName "$computerName"
scutil --set HostName "$computerName"
scutil --set LocalHostName "$computerName"
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName "$computerName"

# Sending computername to Jamf
"$jamf" setcomputername -name "$computerName"

echo "Computer name set to $computerName!"
exit 0
