#!/usr/bin/env bash

echo "STARTING ROS DENSE_FLOW TSN DOCKER..."
cat banner.txt
MACHINENAME=tsn_denseflow
ISTHERENET=`docker network ls | grep br0`
if [ -z "$ISTHERENET" ]
then
      echo "docker network br0 not up. creating one..."
      docker network create \
        --driver=bridge \
        --subnet=172.28.0.0/16 \
        --ip-range=172.28.5.0/24 \
        --gateway=172.28.5.254 \
        br0
else
      echo "found br0 docker network."
fi

nvidia-docker run --rm -it -h $MACHINENAME --network=br0 --ip=172.28.5.2 dt bash -c "source /catkin_ws/devel/setup.bash && /root/ros_catkin_ws/install_isolated/bin/roslaunch dense_flow df.launch"
