#!/bin/bash
DIR_BIN=`dirname $(readlink -f $0)`
cd $DIR_BIN

#./launch_all_plants.sh &
sudo nmcli d wifi hotspot ifname wlan0 ssid Lord_Voldemodem password harrypotter
