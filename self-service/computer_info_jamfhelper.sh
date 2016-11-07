#!/bin/sh

#
# adapted by github.com/smashism
# created 2015-03-12
# last updated 2016-11-07 - change from cocoaDialog to jamfHelper
# uses jamfHelper to display computer information to user
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

#jamfHelper variables

windowType="utility"
title=""
heading="Your Computer Info"
description="Computer IP addresses are: 
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

"/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfhelper" -windowType "$windowType" -windowPosition "$windowPosition" -title "$title" -heading "$heading" -description "$description"  -icon "$icon" -iconSize "$iconSize" -button1 "Close" -defaultButton 1 -countdown "$timeout" -timeout "$timeout"
