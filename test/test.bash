#!/bin/bash
# SPDX-FileCopyrightText: 2024 Akira Matsumoto <akiram8427@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build
source $dir/.bashrc

ros2 run random_service random_generator &
ps aux | grep random_generator
NODE_PID=$!
ps aux | grep random_generator
ros2 service list
ps aux | grep random_generator
kill $NODE_PID
