#!/bin/bash

disk_usage=$(df -h --output=pcent / | sed -n '2p')
echo "$disk_usage"
