#!/bin/bash

broker_address=localhost
broker_port=1883

pa_t=plant_alarm_topic
wa_t=water_alarm_topic
m_t=moisture_topic
a_t=ambient_light_topic
t_f="log/time.csv"

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

# concat all the files to one log file width 4 columns
rm -f log/all.csv
touch log/all.csv

#get length of all files
pa_l=$(wc -l < "$pa_f")
wa_l=$(wc -l < "$wa_f")
m_l=$(wc -l < "$m_f")
a_l=$(wc -l < "$a_f")

# get the shortest file length
min_l=$pa_l
if [ $wa_l -lt $min_l ]; then
    min_l=$wa_l
fi
if [ $m_l -lt $min_l ]; then
    min_l=$m_l
fi
if [ $a_l -lt $min_l ]; then
    min_l=$a_l
fi

header="Time,Plant alarm,Water alarm,Moisture level,Ambient light"
echo "$header" > log/all.csv

# concat all the files to one log file width 4 columns
for ((i=1; i<=$min_l; i=i+60))
do
    #add all values to a string
    string=$(sed -n "${i}p" $t_f),
    string+=$(sed -n "${i}p" $pa_f),
    string+=$(sed -n "${i}p" $wa_f),
    string+=$(sed -n "${i}p" $m_f),
    string+=$(sed -n "${i}p" $a_f)
    #remove all newlines
    string=$(echo "$string" | tr -d '\n')
    #write string to file
    echo "$string" >> log/all.csv
done

