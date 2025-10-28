#!/bin/bash

###
#
#            Name:  set_computername-sn.sh
#     Description:  This script is designed to set a computer name during automated enrollment as follows:
#                   1- Get serial name
#                   2- Format the computer name
#                   3- Set computer name/hostname/local hostname and NetBIOSName using formatted name
#                   4- To be overly thorough, use jamf setcomputername to set name as well
#
###

# Checking jamf location
jamf=$(which jamf)

# Getting the logged-in user
serialNumber=$( /usr/sbin/system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' )

# Get Model Name
modelName=$( /usr/sbin/system_profiler SPHardwareDataType | grep "Model Name" | awk '{print $3,$4}' )

if [[ "$modelName" == *"MacBook Air"* ]]; then
  computerName="${serialNumber}MBA"
elif [[ "$modelName" == *"MacBook Pro"* ]]; then
  computerName="${serialNumber}MBP"
elif [[ "$modelName" == *"Mac mini"* ]]; then
  computerName="${serialNumber}MM"
elif [[ "$modelName" == *"iMac"* ]]; then
  computerName="${serialNumber}IM"
elif [[ "$modelName" == *"Mac Studio"* ]]; then
  computerName="${serialNumber}MS"
else
  computerName="${serialNumber}MAC"
fi

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
