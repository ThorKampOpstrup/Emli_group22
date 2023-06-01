#!/bin/bash
LOG_FILE=$1

echo "Terminating child scripts..."
while read -r pid; do
    echo "Killing PID: $pid"
    kill "$pid"
done < "$LOG_FILE"
rm "$LOG_FILE"