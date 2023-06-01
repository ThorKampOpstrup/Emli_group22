WATER_ALARM="/water_alarm_topic"

water_alarm_callback() {
  local msg="$1"
  echo "$msg"
  local numeric_value="${msg#*: }"
  numeric_value=$(echo "$numeric_value" | tr -dc '[:digit:]')
#   echo "Numerical value: $numerical_value"
#   if (( numeric_value == 0 )) ; then
#     WATER_ALARM_ACTIVE=1
#     echo "Water alarm active"
#   else
#     WATER_ALARM_ACTIVE=0
#   fi
}


ros2 topic echo $WATER_ALARM | while IFS= read -r line; do water_alarm_callback "$line"; done &