#!/bin/sh

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
