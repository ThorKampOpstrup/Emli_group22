#!/bin/bash

# Get a list of active topics
topics=$(ros2 topic list)

# Iterate through the list and unsubscribe or stop publishing on each topic
for topic in $topics; do
    echo "Killing topic: $topic"

    # Unsubscribe from the topic
    ros2 topic unsubscribe "$topic" 2>/dev/null

    # Stop publishing on the topic
    ros2 topic pub "$topic" --once '{}' 2>/dev/null
done
