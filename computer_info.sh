#!/bin/sh

#
# adapted by github.com/smashism
# last update 2015-03-12
# uses cocoaDialog to display computer information to user
# helpful for troubleshooting if user can't find info themselves
#
# offered AS IS with no warranty or guarantee
#
# "If we hit that bullseye, the rest of the dominoes should fall like a house of cards. Checkmate."
#

IPAddresses=`ifconfig | grep " active" -B3 | grep "inet " | cut -d " " -f2`
CurrentUser=`who | grep "console" | awk '{print $1}'`
computername=`jamf getComputerName | cut -d ">" -f2 | cut -d "<" -f1`
OSVersion=`sw_vers | grep "ProductVersion" | awk '{print $2}'`
en1MACAddress=`ifconfig en1 | grep "ether" | cut -d" " -f2`
en0MACAddress=`ifconfig en0 | grep "ether" | cut -d" " -f2`
TotalRam=`system_profiler SPHardwareDataType | grep "Memory:" | cut -d":" -f2`
BootVolume=`system_profiler SPSoftwareDataType | grep "Boot Volume:" | cut -d":" -f2`
TotalBootDriveSize=`df -g / | tail -1 | awk '{print $2}'`
AvailBootDriveSize=`df -g / | tail -1 | awk '{print $4}'`
PercentUsed=`df -g / | tail -1 | awk '{print $5}'`


/Library/Application\ Support/JAMF/bin/cocoaDialog.app/Contents/MacOS/cocoaDialog msgbox \
--title "" --text "Your Computer Info" \
--icon "info" \
--informative-text "Computer IP addresses are: 
$IPAddresses
Current Logged on user is $CurrentUser
Computer name is $computername
OS version is $OSVersion
Wired MAC Address is $en0MACAddress
Wireless MAC Address is $en1MACAddress
Total RAM (Memory):$TotalRam
Boot Volume:$BootVolume
- Total size: $TotalBootDriveSize GB
- Free space: $AvailBootDriveSize GB
- Percent Used: $PercentUsed" --button1 "OK" --quiet
