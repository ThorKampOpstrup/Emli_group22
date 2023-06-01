#!/bin/bash

broker_address=localhost
broker_port=1883

pa_t=plant_alarm_topic
wa_t=water_alarm_topic
m_t=moisture_topic
a_t=ambient_light_topic


# Function to handle SIGINT signal
function handle_sigint() {
    echo "Stopping the program..."
    
    # Exit the script
    exit 0
}

# Register the SIGINT signal handler
trap handle_sigint SIGINT

stty -F /dev/ttyACM0 115200 raw -echo -echoe -echok

# Loop to continuously read data from UART
while true
do
    # Read data from the serial port
    INPUT=$(head -n 1 /dev/ttyACM0)
    
    PLANT_ALARM=$(echo "$INPUT" | cut -d ',' -f1)
    mosquitto_pub -h $broker_address -p $broker_port -t $pa_t -m "$PLANT_ALARM"
    # echo "$PLANT_ALARM, published to $pa_t"

    WATER_ALARM=$(echo "$INPUT" | cut -d ',' -f2)
    mosquitto_pub -h $broker_address -p $broker_port -t $wa_t -m "$WATER_ALARM"
    # echo "$WATER_ALARM, published to $wa_t"

    MOISTURE=$(echo "$INPUT" | cut -d ',' -f3)
    mosquitto_pub -h $broker_address -p $broker_port -t $m_t -m "$MOISTURE"
    # echo "$MOISTURE, published to $m_t"
    
    AMBIENT_LIGHT=$(echo "$INPUT" | cut -d ',' -f4-)
    mosquitto_pub -h $broker_address -p $broker_port -t $a_t -m "$AMBIENT_LIGHT"
    # echo "$AMBIENT_LIGHT, published to $a_t"
done