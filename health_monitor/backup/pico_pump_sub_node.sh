#!/bin/bash

# Duration in seconds
duration=5

# Start time
start_time=$(date +%s)

# Loop for the specified duration
while true; do
  # Check if the duration has elapsed
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  if (( elapsed_time >= duration )); then
    break
  fi

  # Send data to Raspberry Pi Pico via serial device file
  echo -e "p" | sudo tee /dev/ttyACM0 > /dev/null

  # Sleep for 1 second before sending the next data
  sleep 1
done
