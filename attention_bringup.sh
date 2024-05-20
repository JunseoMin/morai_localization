#!/bin/bash
catkin_dir=/home/immersion/catkin_ws/
dmsa_dir=/home/immersion/attention/dmsa_slam_ws/
fast_lio_dir=/home/immersion/attention/fast_lio_ws/
livox_dir=/home/immersion/attention/ws_livox/

##sudo##
password=orin
echo $password | sudo -S true
tmux -X new-session -s ros_session

# Create a new tmux session
tmux new-session -d -s ros_session

# Window 1: roscore
tmux rename-window -t ros_session:0 'roscore'
tmux send-keys -t ros_session:0 "roscore" C-m

# Give roscore some time to start
sleep 5

# Window 3: Livox driver
tmux new-window -t ros_session:1 -n 'livox_driver'
tmux send-keys -t ros_session:1 "cd $livox_dir; source devel/setup.bash; roslaunch livox_ros_driver2 msg_HAP.launch" C-m
sleep 2

# Window 4: Fast LIO
tmux new-window -t ros_session:2 -n 'fast_lio'
tmux send-keys -t ros_session:2 "cd $fast_lio_dir; source devel/setup.bash; roslaunch fast_lio mapping_hap.launch" C-m
sleep 2

# Window 2: bringup hunter
tmux new-window -t ros_session:3 -n 'bringup_hunter'
tmux send-keys -t ros_session:3 "echo $password | sudo -S true; cd $catkin_dir; source devel/setup.bash; rosrun immersion_bringup bringup_can2usb.bash; roslaunch immersion_launch attention_mapping_launch.launch" C-m

# Attach to the tmux session
tmux attach-session -t ros_session
