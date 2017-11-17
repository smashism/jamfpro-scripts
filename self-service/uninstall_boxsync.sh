#!/bin/bash

###
#
#            Name:  uninstall_boxsync.sh
#     Description:  This script is designed to uninstall the Box Sync app and its
#                   related components.
#          Author:  Emily Kausalik
#         Created:  2017-11-06
#   Last Modified:  2017-11-06
#
###

#################
### Variables ###
#################

# Items at the system level to be removed
systemItems=(
  /Applications/Box\ Sync.app
  /Library/PrivilegedHelperTools/com.box.sync.iconhelper
  /Library/PrivilegedHelperTools/com.box.sync.bootstrapper
  /private/var/db/receipts/com.box.pkg.boxsync.bom
  /private/var/db/receipts/com.box.pkg.boxsync.plist
)

# Items at the user level to be removed
userItems=(
  Library/Logs/Box/Box\ Sync/
  Library/Box\ Sync/
  Library/Application\ Support/Box/Box\ Sync/
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
echo "Killing Box Sync app and Box Edit if installed"
killall "Box Sync"
killall "Box Edit"
echo "Please note, this does not delete the Box Sync folder contents, just the application and related services."
echo "To uninstall Box Edit, please download the Box Edit installer and select Uninstall when prompted."

# Delete system level items
deleteItems systemItems[@]

# Delete user level items
for dirs in /Users/*/
		do
			deleteItems userItems[@] "${dirs}"
		done

exit 0
