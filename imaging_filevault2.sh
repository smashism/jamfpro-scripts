#!/bin/bash

###
#
#            Name:  imaging_filevault2.sh
#     Description:  This script is designed to prepare FileVault 2 on a machine during imaging as follows:
#                   1- Add a policy to the JSS using preferred FileVault 2 encryption method:
#                      - Set to Ongoing, scoped to All computers (or eligible FV2 smart group).
#                      - Set the Trigger to Custom, using imaging_filevault2 or a trigger of your choice (make sure to reflect it below).
#                      - Add Disk Encryption, with Require FileVault 2 set to At next login.
#                   2- Add script to the JSS, setting it to run by default At reboot.
#                   4- Add to imaging configuration
#            Note:  Works best for 1x1 laptop deployments where only one person typically signs into the laptop. It may be advisable
#                   to have a second policy run that creates a standard user with FV2 rights on the machine as a backup.
#          Author:  Emily Kausalik (drkausalik@gmail.com)
#         Created:  2017-05-26
#   Last Modified:  2017-05-26
#
#         Version:  1.0
#                   - Initial commit
#
###

# Figure out the correct jamf agent
jamf=$(which jamf)

# Run FileVault 2 policy for next logon
"$jamf" policy -event imaging_filevault2

exit 0
