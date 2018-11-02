#!/usr/bin/env bash
MYDIR=/dense_flow
source /root/ros_catkin_ws/install_isolated/setup.bash
mkdir -p $MYDIR/catkin_ws/src
cd $MYDIR/catkin_ws/src
git clone https://github.com/frederico-klein/create_video.git
#git clone https://github.com/ros-perception/vision_opencv.git
#latest version is too new. it requires opencv3 and since i don't want to install
#2 versions or change the tsn code to use opencv3 we will use an older version of
# cv_bridge
wget https://github.com/ros-perception/vision_opencv/archive/1.11.16.zip
unzip 1.11.16.zip
rm 1.11.16.zip

cd ..
## we need to make sure it uses our own version of opencv, so we don't have 2 copies and have to compile it twice...
catkin_make -DOpenCV_DIR=$MYDIR/3rd-party/opencv-2.4.13  #|| catkin_make -DOpenCV_DIR=$MYDIR/3rd-party/opencv-2.4.13/cmake
#catkin_make -DOpenCV_DIR=/dense_flow/3rd-party/opencv-2.4.13
# rebuild 1
