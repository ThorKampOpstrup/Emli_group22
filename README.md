# Emli_group22
The project was done by Benjamin Longet, Peter Nielsen and Thor Opstrup.

# Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Usage](#usage)

## Introduction <a name="introduction"></a>
This Git repository was created as a part of the Embedded Linux course at University of Southern Denmark. The purpose of the project was to create an Embedded Plant Watering System, consisting of a Raspberry Pi, Raspberry Pico and an ESP8266. The project definition with Functional- and Nonfunctional requirements can be found in the [Requirements.pdf](emli_2023_project_info_v2-1.pdf).

## Features <a name="features"></a>
A list with describtion the main folders of the project, with a short description of the functionality of each folder can be read here.
Normally each folder would have it own read me, but it has been written on the main page, so everything the different folders include can be read here down in usage. 

| File Path        | Functionality                                 |
| ---------------- | --------------------------------------------- |
| `health_monitor`  | The folder includes the bash scripts for monitoring the health status of our Raspberry Pi     |
| `html` | The folder includes the php, html, .log, and .csv files in the project for our webserver.  |
| `log` | The folder includes different .csv files used for logging|
| `log_backup`  | The folder includes backup of the data used for logging the visible tests in the report.     |
| `plants` | The folder used to save informations for multiple plants. Only 1 file right now, as we only have one plant |
| `scripts`  |  The folder includes the bash scripts for all the message topics.      |


## Usages <a name=usage></a>
Define a plant in the plants folder, an example can be found in the folder.
The plant file should contain the following information, order does not matter:
        
        #id
        1
        #port
        /dev/ttyACM0
        #moisture threshold
        60
        #remote ip
        10.42.0.222

To launch a specific plant(not from file), run command:

        ./launch_plant_remote.sh $id $port $moisture_threshold $remote_ip

Or to launch all plants, run, this will launch nodes for all plants in the plants folder:

        ./launch_all_plants.sh

To kill all nodes, run:

        ./kill_ros_nodes.sh pids.log

To launch the monitor topic for a specific id, run:

        ./scripts/show_data.sh $id

A short description of each file in each path. 

### health_monitor
- `cpu_load`.sh: Bash script, cpu load
- `cpu_temp`.sh: Bash script, cpu temperature
- `disk_space`: Bash script, disk space
- `log_to_csv`.sh: Bash script that executes the other bash scripts and save them in a .csv
- `network_traffic`.sh: Bash script, network traffic
- `ram_usage`.sh: Bash script, ram usage
- `system_info`.csv: log file

### html
- `all1.csv`: CSV file hard linked to the csv file in log.
- `chart.js`: Javascript for showing the graph ofline.
- `Fail2ban.log`: Hard link to the log file for fail2ban.
- `graphv2.php`: Graph of sensors and alarm with download bottom.
- `index.html`: Welcome page.
- `login.php`: Safety side with password to see the log for fail2ban.
- `plot2_csv.php`: Shows the RPI healt moniting data.
- `plot_pump.php`: Shows when the pump was activated in graph form.
- `pump1.csv`: CSV file hard linked to the csv file in lag.
- `system_info.csv` CSV file hard linked to the health monitoring log
- `uptime.php`: Shows the uptime linux command

### log
- `all1.csv`: CSV file with id for logging timestamp, ambient light, moisture, pump and water alarm for one plant.
- `ambient_light_topic1.csv`: Log file.
- `moisture_topic1.csv`: Log file.
- `plant_alarm_topic1.csv`: Log file.
- `water_alarm_topic1.csv`: Log file.
- `pump1.csv`: Logfile with timestampt for when the pump is used.
- `time1.csv`: Logfile of the timestamp, matching the lines in 4 sensor topics. 

### plants
- `plant1`: example of a plant file.

### scripts
- `btn_press.sh`: Publisher node for bottom press(*pump_request*).
- `check_last_pump.sh`: checks if 12 hours have passed since last pump(publishes on *pump_reuest*)
- `generate_colected_log.sh`: Collect all individually logged data to one file one data-point per minute, deletes the content of the four sensor file when ran.
- `kill_ros_nodes.sh`: Kills all pids in the passed file
- `log_sensor.sh`: Subscriber node that logs the different topics to each own .csv file
- `plant_node.sh`: Reads data from UART and publish it on 4 different message topics for the 2 alarms and two sensors with an ID attached for the possibility of multiple plants.
- `pump_controller.sh`: Subscriber node, that sends signal to the Pico to water the plant, whenever appropriate to the functional requirements.
- `remote_node.sh`: Subscriber node led control on ESP8266
- `show_data.sh`: Subscriber node for debugging tool to show the data of the different topics.

### run web server
    sudo apt-get install apache2 php
    cd /var/www
    sudo chown -R www-data:www-data /var/www/html
    sudo chmod -R g+w html
    sudo usermod -a -G www-data pi

### Setup to run on boot
Follow below steps to run the project on boot.

1. Open a terminal and `touch /etc/rc.local`
2. Open the file with `sudo nano /etc/rc.local`

    *Add the following lines to the file:*

        #!/bin/bash 
        $PATH_TO/boot.sh
        exit 0

4. Open file with `sudo nano /etc/systemd/system/rc-local.service`

    *Add the following lines to the file:*

        **[Unit]**
        Description=/etc/rc.local Compatibility
        ConditionPathExists=/etc/rc.local

        [Service]
        Type=forking
        ExecStart=/etc/rc.local start
        TimeoutSec=0 
        StandardOutput=tty
        RemainAfterExit=yes 
        SysVStartPriority=99
        
        [Install]
        WantedBy=multi-user.target
**Addition:**
    *One could just add teh content of boot.sh to the rc.local file, but for ease of acces for the user it is placed in boot.sh*

### If old data is shown or downloaded, it is most likely a missing link, perform following step depending on the missing link:
**cd to root of this git!**
        
        ln log/all1.csv html/all1.csv 
        
        sudo ln html/* /var/www/html/

        ln log/pump1.csv html/pump1.csv
        
        ln html/pump1.csv /var/www/html/pump1.csv

### If the program still does not start;
Try trouble shooting by starting "./launch_all_plant.sh" and se what information is shown and what is not. Note that it will say Waiting for server, as 2 of the nodes ping the remote, and waits for answers before proceeding. The btn node til print waiting .... as ling as no button press is detected.