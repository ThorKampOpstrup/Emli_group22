#!/bin/bash
LOG_FILE="pids.log"

echo "Killing all logged processes"
./kill_all_logged.sh $LOG_FILE

echo "Launching all plants"


#print out all lines of files in path plants/
for file in plants/*
do
    
    echo "Plant file: $file"
    #lines in file
    num_lines=$(wc -l < $file)
    for ((i=1; i<=$num_lines; i=i+2))
    do
        line=$(sed -n "$i"p $file)
        if [[ $line == \#id* ]]
        then
            id=$(sed -n "$((i+1))"p $file)
        fi
        if [[ $line == \#port* ]]
        then
            port=$(sed -n "$((i+1))"p $file)
        fi
        if [[ $line == \#moisture* ]]
        then
            moisture_threshold=$(sed -n "$((i+1))"p $file)
        fi
    done
    echo "id: $id"
    echo "port: $port"
    echo "moisture_threshold: $moisture_threshold"
    echo "Launching plant $id"

    ./launch_plant_remote.sh $id $port $moisture_threshold &
    pid=$!
    echo "$pid" >> "$LOG_FILE"
done