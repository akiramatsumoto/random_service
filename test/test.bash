#!/bin/bash

cleanup () {
    if ps -p $NODE_PID > /dev/null; then
        kill $NODE_PID
    else
        echo "Process $NODE_PID not found, skipping kill"
    fi
    exit 1
}

trap "cleanup" EXIT

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build
source install/setup.bash  # ROS 2 ワークスペースのセットアップ

# サービスの立ち上げ
ros2 run random_service random_generator &
NODE_PID=$!

# サービスの存在を確認
timeout 10 bash -c 'until ros2 service list | grep -q "/query"; do sleep 1; done'
if [ $? -ne 0 ]; then
    cleanup
fi

# レスポンスの正当性を確認
response=$(ros2 service call /query random_service/srv/Query "{num_digit: 1}" | grep -oP "n_digit_number=\K[0-9]+")
if [ $? -ne 0 ] || [ -z "$response" ]; then
    cleanup
fi

# 引数に-1を指定した場合
response=$(ros2 service call /query random_service/srv/Query "{num_digit: -1}")
echo "$response" | grep -q "The 'num_digit' field must be an unsigned integer" || cleanup

# 引数にaを指定した場合
response=$(ros2 service call /query random_service/srv/Query "{num_digit: a}")
echo "$response" | grep -q "invalid literal for int() with base 10" || cleanup

# 終了
kill $NODE_PID
exit 0

