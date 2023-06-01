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

pa_f=log/$(echo "$pa_t" | awk -F "_" '{print $1}').csv
wa_f=log/$(echo "$wa_t" | awk -F "_" '{print $1}').csv
m_f="${m_t%_topic}"
m_f="log/${m_f#*_}.csv"
a_f="${a_t%_topic}"
a_f="log/${a_f#*_}.csv"
t_f="log/time.csv"

#open csv file

while true
do  
    echo "HELO"
    mosquitto_sub -h $broker_address -p $broker_port -t $pa_t -t $wa_t -t $m_t -t $a_t -F "%t %p" | while read -r message
    do
        topic=$(echo $message | cut -d' ' -f1)
        message=$(echo $message | cut -d' ' -f2)
        echo $message
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
