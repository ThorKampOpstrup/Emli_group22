#!/bin/bash
time_th=10

broker_address=localhost
broker_port=1883

n=$(ls -1 ../log/pump*.csv 2>/dev/null | wc -l)
for ((id=1; id<=$n; id++))
do
    p_f=../log/pump$id.csv

    pr_t=pump_request_topic$id

    pump=$(tail -n 1 $p_f)

    IFS=',' read -r -a array <<< "$pump"
    last_time=${array[0]}

    current_time=$(date +%s)
    echo $current_time

    if [ $((current_time - last_time)) -gt $time_th ]
    then
        echo "pump $id plz"
        mosquitto_pub -h $broker_address -p $broker_port -t $pr_t -m "2"
    else
        echo "pump $id no"
    fi
done