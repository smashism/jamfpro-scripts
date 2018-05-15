#!/bin/bash

nameString="$4" # What to put in a name string
plistName="$5" # Name of the plist file (e.g., com.planetexpress.expendable.plist)
plistPath="$6" # Path to plist file (e.g., /Users/Shared/Careerchips)

currentDate=$(date +"%Y-%m-%d %H:%M:%S") # Creates date in format Jamf can use for date-based data type EA

defaults write $plistPath/$plistName name "$nameString" # Double-duty: will make plist if doesn't exist, then write the value!
defaults write $plistPath/$plistName date "$currentDate" # Date can be used in Jamf EA with "Date" data type.

# Dosvedanya, comrade!

exit 0
