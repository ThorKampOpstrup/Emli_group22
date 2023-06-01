#!/bin/bash
# Purpose: Monitor CPU utilization
# Add cpu usage to file cpu_log.csv
# -------------------------------------------------------

# Get the date
DATE=$(date +%m/%d/%Y)
USAGE=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Write to file
echo "$DATE,$USAGE" >> cpu_log.csv
