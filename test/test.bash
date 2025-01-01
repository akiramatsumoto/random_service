#!/bin/bash

cleanup() {
    kill $NODE_PID
    exit 1
}

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build
source $dir/.bashrc

ros2 run random_service random_generator &
NODE_PID=$!
ros2 service list | grep /query
[ $? = 0 ] || cleanup
ros2 service call /query random_service/srv/Query "num_digit: 1"
[ $? = 0 ] || cleanup
ros2 service call /query random_service/srv/Query "num_digit: -1"
[ $? = 1 ] || cleanup
ros2 service call /query random_service/srv/Query "num_digit: -1"
[ $? = 1 ] || cleanup
kill $NODE_PID
echo "テストは成功しました"
exit 0
