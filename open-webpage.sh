#!/bin/sh

###
#
#            Name:  open-webpage.sh
#     Description:  Opens a webpage (or any URL shortcode) in the correct user context.
#          Author:  Emily KW
#         Created:  2021-07-28
#			       Note:	https://scriptingosx.com/2020/08/running-a-command-as-another-user/
#
###

################################## VARIABLES ##################################

currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )

# get the current user's UID
uid=$(id -u "$currentUser")

# convenience function to run a command as the current user
# usage:
#   runAsUser command arguments...
runAsUser() {  
  if [ "$currentUser" != "loginwindow" ]; then
    launchctl asuser "$uid" sudo -u "$currentUser" "$@"
  else
    echo "no user logged in"
    # uncomment the exit command
    # to make the function exit with an error when no user is logged in
    # exit 1
  fi
}


################################ MAIN PROCESS #################################

# open a website in the current user's default browser
# set in variable 4 on a policy's script payload

runAsUser /usr/bin/open "$4"

exit 0

