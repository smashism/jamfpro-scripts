#!/bin/bash

# adapted by github.com/smashism
# created 2015-03-12
# updated 2016-11-07 - changed from cocoaDialog to jamfHelper
# lets user get browser versions for updating
#
# provided AS IS with no guarantee or warranty
# "You want the rest of the 'champaggin'?" "No… and it's pronounced 'cham-pain.'"

# Get browser version info
theChrome=$(defaults read "/Applications/Google Chrome.app/Contents/Info" CFBundleShortVersionString)
theFox=$(defaults read "/Applications/Firefox.app/Contents/Info" CFBundleShortVersionString)
theSafari=$(defaults read "/Applications/Safari.app/Contents/Info" CFBundleShortVersionString)
Silverlight=$(defaults read "/Library/Internet Plug-ins/Silverlight.plugin/Contents/Info" CFBundleShortVersionString)

windowType="utility"
windowPosition=""
title=""
heading="Your Browser Versions"
description="Your Firefox version is: $theFox
Your Chrome version is: $theChrome
Your Safari version is: $theSafari
Your Silverlight version is: $Silverlight"
icon="/Applications/Safari.app/Contents/Resources/compass.icns"
iconSize=""

"/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfhelper" -windowType "$windowType" -windowPosition "$windowPosition" -title "$title" -heading "$heading" -description "$description"  -icon "$icon" -iconSize "$iconSize" -button1 "Close" -defaultButton 1 -countdown "$timeout" -timeout "$timeout"
