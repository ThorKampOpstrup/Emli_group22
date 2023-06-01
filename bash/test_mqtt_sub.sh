#!/bin/bash

# Define MQTT broker address and port
broker_address="127.0.0.1"
broker_port=1883

# Define MQTT topic and message
topic=my/testTopic

# Publish the message to the MQTT topic

mosquitto_sub -h $broker_address -p $broker_port -t $topic | while read -r message
do
    echo "Message: $message"
done