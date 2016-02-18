#!/bin/bash

# This script updates the time servers on a Mac to look at $workplace's
# on-prem NTP because the external firewalls at $workplace block
# all internet-based NTPs, including Apple's. The primary will be
# changed to $workplace's, then the secondary will be Apple's, so that
# the correct time is attainable both on- and off-prem.
#
# Script by smashism 2015/07/23 for $workplace
#


# Set timezone

# /usr/sbin/systemsetup -settimezone "America/Chicago"

# Primary Time server for Company Macs
TimeServer1=ntp1.corp.company.com
# Secondary Time servers for Company Macs
TimeServer2=ntp2.corp.company.com
TimeServer3=time.apple.com

# Set the primary network server with systemsetup -setnetworktimeserver
# Using this command will clear /etc/ntp.conf of existing entries and
# add the primary time server as the first line.
/usr/sbin/systemsetup -setnetworktimeserver $TimeServer1

# Add the secondary time server as the second line in /etc/ntp.conf
echo "server $TimeServer2" >> /etc/ntp.conf
echo "server $TimeServer3" >> /etc/ntp.conf
