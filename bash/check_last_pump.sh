#!/bin/bash
id=$1
time_th=10

p_f=../log/pump$id.csv

broker_address=localhost
broker_port=1883

pr_t=pump_request_topic$id

pump=$(tail -n 1 $p_f)

IFS=',' read -r -a array <<< "$pump"
last_time=${array[0]}

current_time=$(date +%s)
echo $current_time

if [ $((current_time - last_time)) -gt $time_th ]
then
    echo "pump plz"
    mosquitto_pub -h $broker_address -p $broker_port -t $pr_t -m "2"
else
    echo "pump no"
fi