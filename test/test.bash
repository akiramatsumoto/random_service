#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build
source $dir/.bashrc

ros2 run random_service random_generator &
NODE_PID=$!
kill $NODE_PID
