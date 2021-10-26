#!/bin/bash

###
#
#            Name:  jamf-policy-event-runner.sh
#     Description:  Add a custom trigger for a secondary policy into variable 4. This script will
#                   then run that trigger within the primary policy.
#          Author:  ekw
#            Date:  2021-10-26
#
###

jamfBinary=$( which jamf )
jamfEvent="$4"

"$jamfBinary" policy -event "$jamfEvent"
