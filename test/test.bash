#!/bin/bash

ng () {
	kill $NODE_PID
	exit 1
}

trap "kill $NODE_PID; exit" EXIT

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build
source $dir/.bashrc

ros2 run random_service random_generator &
NODE_PID=$!

timeout 10 bash -c 'until ros2 service list | grep -q "/query"; do sleep 1; done' || ng

kill $NODE_PID
exit 0
