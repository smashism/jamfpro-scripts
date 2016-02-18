#!/bin/sh

#  SendHelpDeskRequest.sh
#  Opens user's default mail client to send an email to the HelpDesk. Hooray!
#
#  Created by smashism on 10/3/14.
#  

# getting user information
computername=$2
username=$3

# set email information
subject="Request Subject"
body="Hello, my username is $3 and my computer's name is $2. I need help with ... "

# send email through default mail client
open "mailto:helpdesk@company.com?subject=$subject&body=$body"
