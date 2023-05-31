#!/bin/bash

cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
cpu_temp=$((cpu_temp / 1000))
echo "$cpu_temp"
