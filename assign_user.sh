#!/bin/bash

###
#
#            Name:  assign_user.sh
#     Description:  This script is designed to run on a recurring frequnecy for
#                   inventory purposes. It does the following:
#                   1- Uses Enterprise Connect keychain entry to get primary user
#                   username.
#                   2- Uses jamf binary to submit that username as the assigned
#                   user on the computer record.
#          Author:  Emily Kausalik
#         Created:  2017-08-16
#   Last Modified:  2017-08-16
#
###

# Check for jamf binary location
jamf=$(which jamf)
echo "Jamf binary is located at: $jamf. Continuing..."

# Get the username of the user signed into Enterprise Connect
ec_username=$(/usr/bin/security find-generic-password -l "Enterprise Connect" | grep "acct" | awk -F "=" '{print $2}' | tr -d "\"")
echo "Current user is $ec_username. Submitting to JSS."
# Run recon to submit the user's username, and queries LDAP for user and location info

"$jamf" recon -endUsername "$ec_username"

exit 0
