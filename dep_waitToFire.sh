#!/bin/bash

# Starting state user and find the jamf binary

loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
jamf=$(which jamf)

# Check if:
# - User is in control (not _mbsetupuser)

until [ "$loggedInUser" != "_mbsetupuser" ]
    do
      sleep 2
      
      # Recheck user
      loggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
    done

"$jamf" policy -event dep_setup -randomDelaySeconds 0

exit 0
