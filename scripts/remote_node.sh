#!/bin/bash

id=$1
m_th=$2
ip_arg="$3"

broker_address=localhost
broker_port=1883

pa_t=plant_alarm_topic$id
wa_t=water_alarm_topic$id
m_t=moisture_topic$id
a_t=ambient_light_topic$id

# URL's
IP_ADDRESS=$ip_arg
BUTTON="/button/a/count"
GREEN_ON="/led/green/on"
GREEN_OFF="/led/green/off"
YELLOW_ON="/led/yellow/on"
YELLOW_OFF="/led/yellow/off"
RED_ON="/led/red/on"
RED_OFF="/led/red/off"

# Global variables
PLANT_ALARM_ACTIVE=1
WATER_ALARM_ACTIVE=1
MOISTURE_VALUE=0
MOISTURE_THRESH=$m_th

# Function to handle SIGINT signal
function handle_sigint() {
    echo "Stopping the program..."
    
    # Exit the script
    exit 0
}

# Register the SIGINT signal handler
trap handle_sigint SIGINT

# subscriber callback functions
# currently assuming the msg to be integer

plant_alarm_callback() {
  local msg="$1"
  local numeric_value="${msg#*: }"
  numeric_value=$(echo "$numeric_value" | tr -dc '[:digit:]')
  if [[ -n "$numeric_value" ]] && ((numeric_value == 1 )) ; then
    PLANT_ALARM_ACTIVE=1
    # echo "Plant alarm active"
  else
    PLANT_ALARM_ACTIVE=0
  fi
}

water_alarm_callback() {
  local msg="$1"
  # echo "$msg"
  local numeric_value="${msg#*: }"
  numeric_value=$(echo "$numeric_value" | tr -dc '[:digit:]')
  # echo "Numerical value: $numerical_value"
  if [[ -n "$numeric_value" ]] && (( numeric_value == 0 )); then 
    WATER_ALARM_ACTIVE=0
  else
    # echo "Water alarm active"
    WATER_ALARM_ACTIVE=1
  fi
}

while true
do  
    mosquitto_sub -h $broker_address -p $broker_port -t $pa_t -t $wa_t -t $m_t -F "%t %p" | while read -r message
    do
        printf "%s" "waiting for Server ..."
        while ! timeout 0.2 ping -c 1 -n $ip_arg &> /dev/null
        do
          printf "%c" "."
          continue
        done
        printf "\n\r"
        topic=$(echo $message | cut -d' ' -f1)
        message=$(echo $message | cut -d' ' -f2)
        # echo "topic: $topic: message: $message"
        if [ "$topic" == "$pa_t" ]; then
            plant_alarm_callback "$message"
        elif [ "$topic" == "$wa_t" ]; then
            water_alarm_callback "$message"
        elif [ "$topic" == "$m_t" ]; then
            MOISTURE_VALUE=$message
        fi
        green_status="on"
        if (( $PLANT_ALARM_ACTIVE == 1 || $WATER_ALARM_ACTIVE == 1 )); then
            curl -s "http://${IP_ADDRESS}${RED_ON}"
            curl -s "http://${IP_ADDRESS}${GREEN_OFF}"
            green_status="off"
            echo "plant alarm or water alarm"
        else
            curl -s "http://${IP_ADDRESS}${RED_OFF}"
        fi
        if (( $MOISTURE_VALUE <= $MOISTURE_THRESH )); then
            curl -s "http://${IP_ADDRESS}${YELLOW_ON}"
            green_status="off"
            echo "moisture to low"
        else
          curl -s "http://${IP_ADDRESS}${YELLOW_OFF}"
        fi
        if [[ $green_status == "on" ]]; then
          curl -s "http://${IP_ADDRESS}${GREEN_ON}"
          echo "okay"
        else
          curl -s "http://${IP_ADDRESS}${GREEN_OFF}"
        fi

    done
done