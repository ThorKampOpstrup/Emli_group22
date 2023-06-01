#!/bin/bash

DIR_BIN=$(dirname $(readlink -f $0))
cd $DIR_BIN

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

#get number of file with name "light*.csv"
n=$(ls -1 ../log/ambient_*.csv 2>/dev/null | wc -l)
echo 
for ((id=1; id<=$n; id++))
do
    # pa_f=../log/$(echo "$pa_t" | awk -F "_" '{print $1}')$id.csv
    # wa_f=../log/$(echo "$wa_t" | awk -F "_" '{print $1}')$id.csv
    # m_f="${m_t%_topic}"
    # m_f="../log/${m_f#*_}$id.csv"
    # a_f="${a_t%_topic}"
    # a_f="../log/${a_f#*_}$id.csv"
    # t_f="../log/time$id.csv"
    pa_f=../log/$pa_t$id.csv
    wa_f=../log/$wa_t$id.csv
    m_f=../log/$m_t$id.csv
    a_f=../log/$a_t$t$id.csv
    t_f="../log/time$id.csv"

    l_f=../log/all$id.csv


    echo "pa_f: $pa_f"
    echo "wa_f: $wa_f"
    echo "m_f: $m_f"
    echo "a_f: $a_f"
    echo "t_f: $t_f"

    # if not
    if [ ! -f "$l_f" ]; then
        echo "File $l_f does not exist."
        touch $l_f
        echo "File touched"
        header="Time,Plant alarm,Water alarm,Moisture level,Ambient light"
        echo "adding header to $l_f"
        echo "$header" > $l_f
        exit 1
    fi

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
        # echo "here"
        echo "$string" >> $l_f
    done

    rm $pa_f $wa_f $m_f $a_f $t_f
done