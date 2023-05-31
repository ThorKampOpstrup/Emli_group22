#!/bin/bash

DIR_BIN=$(dirname $(readlink -f $0))
cd $DIR_BIN

filename="system_info.csv"
header="Time,CPU Usage,CPU Temperature,Disk Usage,RAM Usage,Bytes Received,Bytes Transmitted"

time=$(date +%Y_%m_%d_%H_%M)
cpu_usage=$(./cpu_load.sh)
cpu_temp=$(./cpu_temp.sh)
disk_usage=$(./disk_space.sh)
ram_usage=$(./ram_usage.sh)
network_in=$(./network_traffic.sh | awk '/Bytes Received/{print $3}')
network_out=$(./network_traffic.sh | awk '/Bytes Transmitted/{print $3}')

if [ ! -f "$filename" ]; then
  echo "$header" >> "$filename"
fi

echo "$time,$cpu_usage,$cpu_temp,$disk_usage,$ram_usage,$network_in,$network_out" >> "$filename"
