#!/bin/bash

###
#
#            Name:  uninstall_citrixreceiver.sh
#     Description:  This script is designed to uninstall Citrix Receiver and its
#                   related components.
#          Author:  Emily Kausalik
#         Created:  2017-11-17
#   Last Modified:  2017-11-17
#
###

#################
### Variables ###
#################

# Items at the system level to be removed
systemItems=(
	/Applications/Citrix\ Receiver.app
  /Library/Application\ Support/Citrix\ Receiver/
  /Users/Shared/Citrix\ Receiver/
	/private/var/folders/_4/0z5ntj996tvdl_k0d9_kpz540000gn/C/com.citrix.receiver.nomas
	/private/var/folders/_4/0z5ntj996tvdl_k0d9_kpz540000gn/C/com.citrix.ReceiverHelper
	/private/var/folders/_4/0z5ntj996tvdl_k0d9_kpz540000gn/C/com.citrix.ReceiverUpdater
  /private/var/db/receipts/com.citrix.ICAClient.bom
  /private/var/db/receipts/com.citrix.ICAClient.plist
)

# Items at the user level to be removed
userItems=(
	Library/Application\ Support/Citrix\ Receiver/
	Library/Caches/Citrix\ Receiver/
  Library/Caches/com.citrix.receiver.noma
	Library/Caches/com.citrix.ReceiverHelper
	Library/Caches/com.citrix.ReceiverUpdater
	Library/Logs/Citrix\ Receiver/
	Library/Preferences/com.citrix.receiver.nomas.plist
	Library/Preferences/com.citrix.ReceiverFTU.AccountRecords.plist
	Library/Preferences/com.citrix.ReceiverHelper.plist
	Library/Preferences/com.citrix.ReceiverUpdater.plist
)

#################
### Functions ###
#################

function deleteItems()
{
	declare -a toDelete=("${!1}")

	for item in "${toDelete[@]}"
		do
			if [[ ! -z "${2}" ]]
				then
					item=("${2}""${item}")
			fi

			echo "Looking for $item"

			if [ -e "${item}" ]
				then
					echo "Removing $item"
					rm -rf "${item}"
			fi
		done
}

####################
### Main Program ###
####################

# Kill the app, if running
echo "Killing Citrix Receiver and related helper tools if running."
killall "Citrix Receiver"
killall "Citrix Receiver Authentication"
killall "Citrix Receiver Helper"
killall "Citrix Service Record Application"

# Delete system level items
deleteItems systemItems[@]

# Delete user level items
for dirs in /Users/*/
		do
			deleteItems userItems[@] "${dirs}"
		done

exit 0
