#!/bin/bash
broker_address=localhost
broker_port=1883

pr_t=pump_request_topic

IP_ADDRESS="10.42.0.222"
BUTTON="/button/a/count"

# Function to handle SIGINT signal
function handle_sigint() {
    echo "Stopping the program..."
    
    # Exit the script
    exit 0
}

while true
do
    count=$(curl -s "http://${IP_ADDRESS}${BUTTON}")
    if [[ $count -gt 0 ]]; then
    # publish button pressed
    # curl -s "http://${IP_ADDRESS}${GREEN_ON}"
        echo "Button has been pressed $count times"
        mosquitto_pub -h $broker_address -p $broker_port -t $pr_t -m "2"
        # ros2 topic pub -1 /pump_request_topic std_msgs/Int16 "{data: 2}"
    fi
done