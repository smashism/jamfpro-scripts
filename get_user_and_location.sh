#!/bin/sh

# gets user and location data to populate computer record
# can run on policy at any time
# by github.com/smashism
# last updated 2015-05-06

# gets the username of the currently logged in user
user=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

# runs recon to submit the user's username, queries LDAP for user and location info
sudo jamf recon -endUsername $user
