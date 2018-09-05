#!/bin/sh

###
#
#            Name:  computer_info_jamfhelper.sh
#     Description:  This script is designed for a Self Service policy that, when run,
#                   displays a jamfHelper popup with information collected from the
#                   Mac, including IP address, current user, computer name, OS version,
#                   MAC addresses, RAM, boot volume size, and usage information.
#          Author:  Emily KW
#         Created:  2017-08-16
#   Last Modified:  2018-09-05
#
###

IPAddresses=$(ifconfig | grep " active" -B3 | grep "inet " | cut -d " " -f2)
currentUser=$( python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");' )
computerName=$(jamf getComputerName | cut -d ">" -f2 | cut -d "<" -f1)
OSVersion=$(sw_vers | grep "ProductVersion" | awk '{print $2}')
en1MACAddress=$(ifconfig en1 | grep "ether" | cut -d" " -f2)
en0MACAddress=$(ifconfig en0 | grep "ether" | cut -d" " -f2)
TotalRam=$(system_profiler SPHardwareDataType | grep "Memory:" | cut -d":" -f2)
BootVolume=$(system_profiler SPSoftwareDataType | grep "Boot Volume:" | cut -d":" -f2)
TotalBootDriveSize=$(df -g / | tail -1 | awk '{print $2}')
AvailBootDriveSize=$(df -g / | tail -1 | awk '{print $4}')
PercentUsed=$(df -g / | tail -1 | awk '{print $5}')

#jamfHelper variables

windowType="utility"
title=""
heading="Hello $currentUser, here is the info for $computerName"
description="Computer IP addresses on this Mac: 
$IPAddresses
OS version is $OSVersion
Wired MAC Address is $en0MACAddress
Wireless MAC Address is $en1MACAddress
Total RAM (Memory): $TotalRam
Boot Volume: $BootVolume
- Total size: $TotalBootDriveSize GB
- Free space: $AvailBootDriveSize GB
- Percent Used: $PercentUsed"
icon=/Applications/Utilities/System\ Information.app/Contents/Resources/ASP.icns

# jamfHelper command

"/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfhelper" -windowType "$windowType" -title "$title" -heading "$heading" -description "$description"  -icon "$icon" -button1 "Close" -defaultButton 1 -countdown "60" -timeout "60"

# "If we hit that bullseye, the rest of the dominoes should fall like a house of cards. Checkmate."
exit 0
