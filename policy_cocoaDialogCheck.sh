#!/bin/bash

###
#
#            Name:  policy_cocoaDialogCheck.sh
#     Description:  This script checks that cocoaDialog is in place on a computer
#                   when a policy needs it (for a popup dialog with requiring cD). 
#                   If present, it does nothing. If not present, it calls
#                   a custom JSS policy trigger to install the icon.
#            Note:  Adapted from policy_CompanyIcon.sh (https://goo.gl/ddKbTl).
#          Author:  Dr. Emily Kausalik (drkausalik@gmail.com)
#         Created:  2016-12-30
#   Last Modified:  2017-01-06
#
###

echo "Checking for cocoaDialog..."

if [ -d "/path/to/cocoaDialog.app" ] ; then
    echo "cocoaDialog present, proceeding..."
else
    echo "cocoaDialog not present, installing..."
    jamf policy -trigger install_cocoaDialog # calls a second policy with custom trigger, rename accordingly
    echo "cocoaDialog installed, proceeding..."
fi

exit 0
