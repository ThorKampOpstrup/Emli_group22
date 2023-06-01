#!/bin/bash
sudo nmcli d wifi hotspot ifname wlan0 ssid Lord_Voldemodem password potter
./launch_all_plants.sh
