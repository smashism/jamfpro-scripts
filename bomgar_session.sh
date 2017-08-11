#!/bin/bash

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

su - "$loggedInUser" -c 'curl -o /tmp/BomgarClient https://corp.bomgar.com/api/start_session -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/601.5.17 (KHTML, like Gecko) Version/9.1 Safari/601.5.17" -d issue_menu=1 -d codeName=remote_help -d "customer.company=Company"'
su - "$loggedInUser" -c '/usr/bin/unzip -o -d /tmp /tmp/BomgarClient'
su - "$loggedInUser" -c '/usr/bin/open /tmp/Bomgar/Double-Click\ To\ Start\ Support\ Session.app'

exit 0
