#!/bin/sh

# Self Service plug-ins cleanup
# by emily 2016-11-07

# Remove old Self Service Plug-ins

echo "Removing old Self Service Plug-ins"
rm -Rf /Library/Application\ Support/JAMF/Self\ Service/Managed\ Plug-ins/*

# Install updated Self Service Plug-ins

echo "Adding new Self Service Plug-ins"
jamf manage

echo "Self Service Plug-ins update complete."
exit 0
