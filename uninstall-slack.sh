#!/bin/bash

###
#
#            Name:  uninstall_slack.sh
#     Description:  This script is designed to uninstall the Slack app and its
#                   related components.
#          Author:  Emily KW
#         Created:  2021-07-25
#
###

#################
### Variables ###
#################

# Items at the system level to be removed
systemItems=(
  /Applications/Slack.app
)

# Items at the user level to be removed
userItems=(
  Library/Application\ Scripts/com.tinyspeck.slackmacgap
  Library/Containers/com.tinyspeck.slackmacgap 
  Library/Containers/com.tinyspeck.slackmacgap/Data/Library/Saved\ Application\ State/com.tinyspeck.slackmacgap.savedState 
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
echo "Killing Slack app process"
killall "Slack"

# Delete system level items
deleteItems systemItems[@]

# Delete user level items
for dirs in /Users/*/
		do
			deleteItems userItems[@] "${dirs}"
		done

# Forgetting app install receipt
pkgutil --forget com.tinyspeck.slackmacgap

exit 0
