#!/bin/bash

###
#
#            Name:  set-ea-value.sh
#     Description:  This script is designed to leverage the API to manually
#                   update the value of an EA on a computer record. Handy
#                   for situations where you don't need information actively
#                   pulled from a Mac but still want to set adhoc when needed.
#                   Values for jamfserver, API credentials, EA ID, EA Name,
#                   and value to input in EA set with parameters to make this
#                   script easly reusable.
#          Author:  Emily Kausalik
#         Created:  2018-01-29
#
###

jamfserver="$4" #set server URL in parameter 4
APIauth=$(openssl enc -base64 -d <<< "$5") #set encoded username:password in parameter 5
getudid=$(system_profiler SPHardwareDataType | grep UUID | awk '{print $3}')
eaID="$6" #set EA ID in parameter 6
eaName="$7" #set EA Name in parameter 7
value="$8" #set desired EA value in paramter 8

# Submit unmanage payload to the Jamf Pro Server
curl -k -s -u "$APIauth" -X "PUT" "https://$jamfserver:8443/JSSResource/computers/udid/$getudid/subset/extension_attributes" \
      -H "Content-Type: application/xml" \
      -H "Accept: application/xml" \
      -d "<computer><extension_attributes><extension_attribute><id>$eaID</id><name>$eaName</name><type>String</type><value>$value</value></extension_attribute></extension_attributes></computer>"

exit 0
