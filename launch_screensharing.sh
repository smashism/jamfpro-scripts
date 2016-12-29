#!/bin/bash

###
#
#            Name:  launch_screensharing.sh
#     Description:  This script is designed to run as a Self Service policy as such:
#                   1- Uses variable 4 to pass through a hostname/IP of the target machine.
#                   2- Uses variable 5 to pass through a username.
#                   3- Uses variable 6 to pass through a password, with special characters
#                      converted into URL encoded characters (https://goo.gl/JNK1g8).
#                   4- Checks for presence of each variable.
#                   5- Opens a VNC connection to the specified hostname with specified username
#                      and password.
#            Note:  This is obviously not incredibly secure, so use with caution. This is ideal
#                   for dashboard displays or other things where username/password information
#                   is a default and already shared widely.
#          Author:  Emily Kausalik (drkausalik@gmail.com)
#         Created:  2016-12-12
#   Last Modified:  2016-12-29
#
###

# Make sure parameter 4 is specified.
if [[ -z $4 ]]; then
    echo "[ERROR] No IP/hostname specified in parameter 4."
    exit 1001
fi

# Make sure parameter 5 is specified.
if [[ -z $5 ]]; then
    echo "[ERROR] No username specified in parameter 5."
    exit 1001
fi

# Make sure parameter 6 is specified.
if [[ -z $5 ]]; then
    echo "[ERROR] No password specified in parameter 6."
    exit 1001
fi

# Open VNC to specified IP with username/password
echo "Opening dashboard $4"
open vnc://"$5":"$6"@"$4"

exit 0
