#!/bin/sh

###
#
#            Name:  dep_logout.sh
#     Description:  This script is the very last thing to happnen during DEP provisioning.
#                   It determines the PID of WindowServer for the logged-in user, kills
#                   WindowServer, and cleans up the SplashBuddy files.
#            Note:  Designed for DEP workflows using SplashBuddy. Can be a script in a Jamf
#                   Pro policy or a payload-free package.
#          Author:  Emily Kausalik (drkausalik@gmail.com)
#         Created:  2017-03-24
#
###

# Determine PID for WindowServer to log out user
WindowServer="$(ps -axc | grep WindowServer | awk '{print $1}')"

# Force user log out
kill -HUP $WindowServer

# Cleanup SplashBuddy
rm -Rf /Library/Application\ Support/SplashBuddy
rm -Rf /Library/Preferences/io.fti.SplashBuddy.plist
rm -Rf /Library/LaunchAgents/io.fti.SplashBuddy.launch.plist

exit 0
