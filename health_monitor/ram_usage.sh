#!/bin/bash

ram_usage=$(free -m | awk 'NR==2{printf "%.2f%%", ($3/($2+$3))*100}')
echo "$ram_usage"
