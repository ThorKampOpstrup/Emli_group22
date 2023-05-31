#!/bin/bash

interface="wlan0" # Replace with the desired network interface (e.g., wlan0)
network_in=$(ifconfig $interface | grep "RX packets" | awk '{print $6}' | tr -d '()')
network_out=$(ifconfig $interface | grep "TX packets" | awk '{print $6}' | tr -d '()')
echo "Network Interface: $interface"
echo "Bytes Received: $network_in"
echo "Bytes Transmitted: $network_out"