#!/bin/bash
# SPDX-FileCopyrightText: 2024 Akira Matsumoto <akiram8427@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build
source $dir/.bashrc

ros2 run random_service random_generator &
NODE_PID=$!
ros2 service list | grep /query
# [ $? = 0 ] || exit 1
ros2 service call /query random_service/srv/Query "num_digit: 1"
# [ $? = 0 ] || exit 1
ros2 service call /query random_service/srv/Query "num_digit: -1"
# [ $? = 1 ] || exit 1
ros2 service call /query random_service/srv/Query "num_digit: -1"
# [ $? = 1 ] || exit 1
response=$(ros2 service call /query random_service/srv/Query "num_digit: 1" | grep n_digit_number | sed 's/.*n_digit_number=\([0-9]*\).*/\1/')
: '
if [ "$response" -ge 0 ] && [ "$response" -le 9 ]; then
    :
else
    exit 1
fi
response=$(ros2 service call /query random_service/srv/Query "num_digit: 2" | grep n_digit_number | sed 's/.*n_digit_number=\([0-9]*\).*/\1/')
if [ "$response" -ge 10 ] && [ "$response" -le 99 ]; then
    :
else
    exit 1
fi
'
kill $NODE_PID
echo "テストは成功しました"
exit 0
