#!/bin/bash

###
#
#            Name:  policy_CompanyLogo.sh
#     Description:  This script checks that the company logo is in place on a computer
#                   when a policy needs it (for a popup dialogue with either jamfHelper
#                   or AppleScript). If present, it does nothing. If not present, it calls
#                   a custom JSS policy trigger to install the icon.
#          Author:  Emily Kausalik (drkausalik@gmail.com)
#         Created:  2016-12-30
#   Last Modified:  2016-12-30
#
###

echo "Checking for Company logo..."

if [ -f "/path/to/CompanyLogo.icns" ] ; then
    echo "Company logo present, proceeding..."
else
    echo "Company logo not present, installing..."
    jamf policy -trigger company_logo_install
    echo "Company logo installed, proceeding..."
fi
