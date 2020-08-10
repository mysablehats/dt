#!/usr/bin/env bash
PASSWD=$1
MYUSERNAME=frederico
DOCKERHOSTNAME=lavine
THISVOLUMENAME=sshvolume3
DOCKERMACHINEIP=172.28.5.2
DOCKERMACHINENAME=dt_legacy
MACHINEHOSTNAME=tsn_denseflow
CATKINWSPATH=/catkin_ws
#export NV_GPU=1
if [ -z "$PASSWD" ]
then
  echo "you need to input your own password to mount the internal ssh volume that is shared between docker and the docker host!"
  echo "usage is: $0 <your-password-here>"
else
  while true; do
    {
    nvidia-docker build -t $DOCKERMACHINENAME .
    #nvidia-docker build --no-cache -t $DOCKERMACHINENAME .
    } ||
    {
    echo "something went wrong..." &&
    break
    }
  echo "STARTING ROS DENSE FLOW DOCKER..."

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
  #nvidia-docker run --rm -it -p 8888:8888 -h $MACHINEHOSTNAME --network=br0 --ip=$DOCKERMACHINEIP $DOCKERMACHINENAME #bash
  {
  docker volume create --driver vieux/sshfs   -o sshcmd=$MYUSERNAME@$DOCKERHOSTNAME:$PWD/catkin_ws -o password=$PASSWD $THISVOLUMENAME
  } ||
  {
    echo "could not mount ssh volume. perhaps vieux is not installed?" &&
    echo "install with: docker plugin install vieux/sshfs" &&
    break
  }
#  nvidia-docker run --rm -it -u root -p 8888:8888 -p 222:22 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $THISVOLUMENAME:/catkin_ws -h $MACHINEHOSTNAME --network=br0 --ip=$DOCKERMACHINEIP $DOCKERMACHINENAME bash # -c "jupyter notebook --port=8888 --no-browser --ip=$DOCKERMACHINEIP --allow-root &" && bash -i
  nvidia-docker run --rm -it -u root -p 223:22 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $THISVOLUMENAME:$CATKINWSPATH -h $MACHINEHOSTNAME --network=br0 --ip=$DOCKERMACHINEIP $DOCKERMACHINENAME bash # -c "jupyter notebook --port=8888 --no-browser --ip=172.28.5.4 --allow-root &" && bash -i


  ## if I add this with -v I can't catkin_make it with entrypoint...
  #-v /temporal-segment-networks/catkin_ws:$PWD/catkin_ws/src
  #
  docker volume rm $THISVOLUMENAME
  break
  done
fi
