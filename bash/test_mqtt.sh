#!/bin/bash

# Define MQTT broker address and port
broker_address=10.42.0.1
broker_port=1883

# Define MQTT topic and message
topic=my/testTopic
message=10

# Publish the message to the MQTT topic
mosquitto_pub -h $broker_address -p $broker_port -t $topic -m "$message"
