#! /bin/bash

# Function to handle sigint signal
function handle_sigint() {
  echo "Stopping the program"
  kill "$ROS2_REQUEST_PUMP_PID"
  exit 0
}

trap handle_sigint SIGINT
# Init publisher
ros2 topic pub -1 /pump_request_topic std_msgs/Int16 &
ROS2_REQUEST_PUMP_PID=$!

# Topics
#PUMP="/pump_request_topic"
WATER_ALARM="/water_alarm_topic"
PLANT_ALARM="/plant_alarm_topic"
MOISTURE_LOW="/moisture_topic"

# URL's
IP_ADDRESS="10.42.0.222"
BUTTON="/button/a/count"
GREEN_ON="/led/green/on"
GREEN_OFF="/led/green/off"
YELLOW_ON="/led/yellow/on"
YELLOW_OFF="/led/yellow/off"
RED_ON="/led/red/on"
RED_OFF="/led/red/off"

# Global variables
PLANT_ALARM_ACTIVE=0
WATER_ALARM_ACTIVE=0
MOISTURE_VALUE=0
MOISTURE_THRESH=20

# subscriber callback functions
# currently assuming the msg to be integer

plant_alarm_callback() {
  local msg="$1"
  local numeric_value="${msg#*: }"
  numeric_value=$(echo "$numeric_value" | tr -dc '[:digit:]')
  if [[ -n "$numeric_value" ]] && ((numeric_value == 0 )) ; then
    PLANT_ALARM_ACTIVE=1
    echo "Plant alarm active"
  else
    PLANT_ALARM_ACTIVE=0
  fi
}

water_alarm_callback() {
  local msg="$1"
  echo "$msg"
  local numeric_value="${msg#*: }"
  numeric_value=$(echo "$numeric_value" | tr -dc '[:digit:]')
  echo "Numerical value: $numerical_value"
  if [[ -n "$numeric_value" ]] && (( numeric_value == 0 )); 
    WATER_ALARM_ACTIVE=1
    echo "Water alarm active"
  else
    WATER_ALARM_ACTIVE=0
  fi
}

moisture_callback() {
  local msg="$1"
  echo "Recieved moisture: $msg"
  MOISTURE_VALUE=$msg
}

# Initialize the subscribers on different process threads
ros2 topic echo $PLANT_ALARM | while IFS= read -r line; do plant_alarm_callback "$line"; done &
ros2 topic echo $WATER_ALARM | while IFS= read -r line; do water_alarm_callback "$line"; done &
ros2 topic echo $MOISTURE_LOW | while IFS= read -r line; do moisture_callback "$line"; done &

# Infinite loop
while true; do
#  curl -s "http://${IP_ADDRESS}${GREEN_ON}"
  # check the button count
  count=$(curl -s "http://${IP_ADDRESS}${BUTTON}")
  if [[ $count -gt 0 ]]; then
    # publish button pressed
   # curl -s "http://${IP_ADDRESS}${GREEN_ON}"
    echo "Button has been pressed $count times"
    ros2 topic pub -1 /pump_request_topic std_msgs/Int16 "{data: 2}"
#  if [[ $count -eq 0 ]]; then
    # publish button pressed
   # curl -s "http://${IP_ADDRESS}${GREEN_ON}"
   # echo "Button has been pressed $count times"
#    ros2 topic pub -1 /pump_request_topic std_msgs/Int16 "{data: 0}"

  fi
  # Start with green on, if nothing more happens it stays on
 # curl -s "http://${IP_ADDRESS}${GREEN_ON}"
  if [[ $PLANT_ALARM_ACTIVE -eq 1 || $WATER_ALARM_ACTIVE -eq 1 ]]; then
    curl -s "http://${IP_ADDRESS}${RED_ON}"
    curl -s "http://${IP_ADDRESS}${GREEN_OFF}"
  else
    curl -s "http://${IP_ADDRESS}${RED_OFF}"
  fi
  if [[ $MOISTURE_VALUE -lt $MOISTURE_THRESH ]]; then
    curl -s "http://${IP_ADDRESS}${YELLOW_ON}"
    curl -s "http://${IP_ADDRESS}${GREEN_OFF}"
  else
    curl -s "http://${IP_ADDRESS}${YELLOW_OFF}"
  fi
  curl -s "http://${IP_ADDRESS}${GREEN_ON}"

 # count=0
  #sleep 0.5
done

#! /bi
