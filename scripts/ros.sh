#!/usr/bin/env bash
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

apt-get update
apt-get install ros-indigo-ros-base ros-indigo-image-transport -y --no-install-recommends

rm -rf /var/lib/apt/lists/*

#kind of annoying, specially considering the steps in this docker...

rosdep init
rosdep update

echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
