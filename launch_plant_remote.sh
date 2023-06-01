#!/bin/bash

id=$1
port=$2
moisture_thresshold=$3

path=bash

# Log file to store child script PIDs
LOG_FILE="pids.log"

# Function to handle SIGINT signal
function handle_sigint() {
    echo "Stopping the program..."
    
    echo "Terminating child scripts..."
    while read -r pid; do
      echo "Killing PID: $pid"
      kill "$pid"
    done < "$LOG_FILE"
    rm "$LOG_FILE"
    # Exit the script
    exit 0
}

# Register the SIGINT signal handler
trap handle_sigint SIGINT

# ./child_script1.sh &
./$path/plant_node.sh $id $port &
pid1=$!
echo "$pid1" >> "$LOG_FILE"

./$path/remote_node.sh $id $moisture_thresshold &
pid2=$!
echo "$pid2" >> "$LOG_FILE"

./$path/pump_controller.sh $id $port $moisture_thresshold &
pid3=$!
echo "$pid3" >> "$LOG_FILE"

./$path/btn_press.sh $id &
pid4=$!
echo "$pid4" >> "$LOG_FILE"

./$path/log_sensors.sh $id &
pid5=$!
echo "$pid5" >> "$LOG_FILE"