#!/usr/bin/env bash

NV_GPU=1 nvidia-docker build -t dt_other .
echo "STARTING ROS DENSE_FLOW TSN DOCKER..."

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
scripts/enable_forwarding_docker_host.sh
cat banner.txt
NV_GPU=1 nvidia-docker run --rm -it -h $MACHINENAME --network=br0 --ip=172.28.5.2 dt_other bash #-c "source /catkin_ws/devel/setup.bash && /root/ros_catkin_ws/install_isolated/bin/roslaunch dense_flow df.launch & rostopic hz /df_extract_gpu/image"
