#!/bin/bash

id=$1
IP_ADDRESS="$2"

broker_address=localhost
broker_port=1883

pr_t=pump_request_topic$id

BUTTON="/button/a/count"

# Function to handle SIGINT signal
function handle_sigint() {
    echo "Stopping the program..."
    
    # Exit the script
    exit 0
}

while true
do
    printf "%s" "waiting for Server ..."
    while ! timeout 0.2 ping -c 1 -n $IP_ADDRESS &> /dev/null
    do
        printf "%c" "."
        continue
    done
    printf "\n\r"
    count=$(curl -s "http://${IP_ADDRESS}${BUTTON}")
    if [[ $count -gt 0 ]]; then
    # publish button pressed
    # curl -s "http://${IP_ADDRESS}${GREEN_ON}"
        echo "Button has been pressed $count times"
        mosquitto_pub -h $broker_address -p $broker_port -t $pr_t -m "2"
        echo "pump requested on $pr_t"
    fi
done