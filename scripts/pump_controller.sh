#!/bin/bash

DIR_BIN=$(dirname $(readlink -f $0))
cd $DIR_BIN

id=$1
port=$2
m_th=$3

broker_address=localhost
broker_port=1883

pr_t=pump_request_topic$id
pa_t=plant_alarm_topic$id
wa_t=water_alarm_topic$id
m_t=moisture_topic$id

p_f=../log/pump$id.csv

# touch $p_f
if [ ! -f "$p_f" ]; then
    echo "File $p_f does not exist."
    touch $p_f
    echo "File touched"
    echo $DIR_BIN/$p_f
    ln $DIR_BIN/$p_f ../html/pump$id.csv
    sudo chown 777 ../html/pump$id.csv
fi

moisture_threshhold=m_th

moisture_level=0
water_alarm=1
plant_alarm=1


pump(){
    local duration=$1
    local port=$2

    # Loop for the specified duration
    echo "Pump on"
    for (( i=0; i<$duration; i++ )); do
        # Send data to Raspberry Pi Pico via serial device file
        echo -ne 'p' > $port
        # echo "p send"
        # Sleep for 1 second before sending the next data
        sleep 1
    done
    echo "Pump off"
}


while true
do  
    mosquitto_sub -h $broker_address -p $broker_port -t $pr_t -t $pa_t -t $wa_t -t $m_t -F "%t %p" | while read -r message
    do
        topic=$(echo $message | cut -d' ' -f1)
        message=$(echo $message | cut -d' ' -f2)
        pump_plz="no"
        touch $p_f
        duration=0
        #get last line of file
        last_line=$(tail -n 1 $p_f)
        # echo "$last_line"
        time_diff=10000000
        #calucalte time difference
        if [ "$last_line" != "" ]; then
            last_time=$(echo $last_line | cut -d',' -f1)
            current_time=$(date +%s)
            time_diff=$(($current_time - $last_time))
            # echo "time diff: $time_diff"
        fi
        if [ "$topic" == "$pr_t" ]; then
            echo "Pump has been requested for: $message sec"
            pump_plz="yes"
            duration=$message
        fi
        if [ "$topic" == "$wa_t" ]; then
            water_alarm=$message
        fi
        if [ "$topic" == "$pa_t" ]; then
            plant_alarm=$message
        fi
        
        
        #if time difference is greater than 10 seconds
        if [ "$time_diff" -gt 20 ]; then
        # if [ "$time_diff" -gt 10 ]; then
            if [ "$topic" == "$m_t" ]; then
                moisture_level=$message
                if (( "$message" <= "$moisture_threshhold" )); then
                    echo "Plant is dry"
                    pump_plz="yes"
                    duration=3
                fi
            fi
            if [ "$topic" == "$wa_t" ]; then
                water_alarm=$message
                echo "help1"
                if [ $message == 1 ]; then
                    echo "Water is to low1"
                    pump_plz="no"
                else 
                    echo "help2"
                fi
            fi
            if [ "$topic" == "$pa_t" ]; then
                plant_alarm=$message
                if [ "$message" == "1" ]; then
                    echo "Plant owerwatered"
                    pump_plz="no"
                fi
            fi
        fi

        if [ "$pump_plz" == "yes" ]; then
            #check water alarm
            if [ $water_alarm == 1 ]; then
                echo "Water is to low2: $water_alarm"
                pump_plz="no"
                break
            fi
            echo "$(date +%s),1,$(date +%Y_%m_%d_%H_%M) " >> $p_f
            pump $duration $port
            echo "$(date +%s),0,$(date +%Y_%m_%d_%H_%M)" >> $p_f
        fi
    done
done