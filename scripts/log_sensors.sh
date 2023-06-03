#!/bin/bash

id=$1

broker_address=localhost
broker_port=1883

pa_t=plant_alarm_topic$1
wa_t=water_alarm_topic$1
m_t=moisture_topic$1
a_t=ambient_light_topic$1


# Function to handle SIGINT signal
function exit_func() {
    echo "Stopping the program..."
    
    # Exit the script
    exit 0
}

# Register the SIGINT signal handler
trap exit_func EXIT

pa_f=log/$pa_t.csv
wa_f=log/$wa_t.csv
m_f=log/$m_t.csv
a_f=log/$a_t.csv
t_f="log/time$id.csv"

#open csv file

while true
do  
    # echo "HELO"
    mosquitto_sub -h $broker_address -p $broker_port -t $pa_t -t $wa_t -t $m_t -t $a_t -F "%t %p" | while read -r message
    do
        topic=$(echo $message | cut -d' ' -f1)
        message=$(echo $message | cut -d' ' -f2)
        # echo $message
        if [ "$topic" == "$pa_t" ]; then
            touch $pa_f
            echo $message >> $pa_f
            touch $t_f
            timestamp=$(date +%Y_%m_%d_%H_%M)
            echo $timestamp >> $t_f
        elif [ "$topic" == "$wa_t" ]; then
            touch $wa_f
            echo $message >> $wa_f
        elif [ "$topic" == "$m_t" ]; then
            touch $m_f
            echo $message >> $m_f
        elif [ "$topic" == "$a_t" ]; then
            touch $a_f
            echo $message >> $a_f
        fi
    done
done
