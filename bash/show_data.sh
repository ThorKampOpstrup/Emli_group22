#!/bin/bash

id=$1

broker_address=localhost
broker_port=1883

pa_t=plant_alarm_topic$1
wa_t=water_alarm_topic$1
m_t=moisture_topic$1
a_t=ambient_light_topic$1
b_t=btn_topic$1


# Function to handle SIGINT signal
function handle_sigint() {
    echo "Stopping the program..."
    
    # Exit the script
    exit 0
}

# Register the SIGINT signal handler
trap handle_sigint SIGINT

#open csv file

while true
do  
    mosquitto_sub -h $broker_address -p $broker_port -t $pa_t -t $wa_t -t $m_t -t $a_t -t $b_t -F "%t %p" | while read -r message
    do
        topic=$(echo $message | cut -d' ' -f1)
        message=$(echo $message | cut -d' ' -f2)
        echo $topic $message
    done
done
