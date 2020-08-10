FROM nvidia/cuda:6.5-devel
ENV DEBIAN_FRONTEND noninteractive


##something is wrong, idk what, but this may help
RUN rm /etc/apt/sources.list.d/cuda.list

RUN apt-get update && apt-get install -y --no-install-recommends \
  unzip \
  wget \
  cmake \
  dpkg \
  build-essential \
  libboost-all-dev \
  python-dev \
  python-numpy \
  libhdf5-serial-dev \
  v4l-utils \
  libv4l-dev \
  libtbb-dev \
  git \
  build-essential \
  cmake \
  checkinstall \
  git \
  wget \
  libatlas-base-dev \
  libboost-all-dev \
  libgflags-dev \
  libgoogle-glog-dev \
  libhdf5-serial-dev \
  libleveldb-dev \
  liblmdb-dev \
  libopencv-dev \
  libprotobuf-dev \
  libsnappy-dev \
  protobuf-compiler \
  #libboost1.55-all-dev \
  python-dev \
  python-numpy \
  python-pip \
  python-setuptools \
  python-scipy \
  unzip \
  #OPENCV STUFF...
  libopencv-dev \
  # can i get away with just this?
  pkg-config \
  libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev \
  libavcodec-dev libavformat-dev libswscale-dev \
  #libv4l-dev libxvidcore-dev libx264-dev \
  libgtk2.0-dev \
  yasm libjpeg-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils \
  # I like this:
  apt-utils \
  ## ssh stuff
  openssh-server\
  libssl-dev \
  && rm -rf /var/lib/apt/lists/*

### now python STUFF
ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
RUN pip install --upgrade pip
#ADD requirements.txt ./
#RUN pip install --trusted-host pypi.python.org -r requirements.txt

##installing opencv as it is a dependency, before we compile dense_flow
WORKDIR /
ADD scripts/opencv.sh /tmp
RUN /tmp/opencv.sh

## now ros things:
ADD scripts/ros.sh /tmp
RUN chmod +x /tmp/ros.sh && /tmp/ros.sh
#RUN echo "source /root/ros_catkin_ws/install_isolated/setup.bash" >> /etc/bash.bashrc

ADD scripts/entrypoint.sh /tmp
ENV ROS_MASTER_URI=http://SATELLITE-S50-B:11311
ENTRYPOINT ["/tmp/entrypoint.sh"]
ADD scripts/start.sh /tmp

# to get ssh working for the ros machine to be functional: (adapted from docker docs running_ssh_service)
RUN mkdir /var/run/sshd \
    && echo 'root:ros_ros' | chpasswd \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    ##in case you want to change the default sshd port
    #&& sed -i 's/Port 22/Port 522/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile" \
    && echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
#add my snazzy banner
ADD banner.txt /tmp/

ADD scripts/catkin_ws.sh /tmp
RUN chmod +x /tmp/catkin_ws.sh && /tmp/catkin_ws.sh

#CMD ["/root/ros_catkin_ws/install_isolated/bin/roslaunch","dense_flow","df.launch"]
## now getting the rars to generate the flows: will be needed for training and testing

#WORKDIR /
#RUN wget http://www.rarlab.com/rar/unrarsrc-5.6.5.tar.gz; tar -xvf unrarsrc-5.6.5.tar.gz; rm unrarsrc-5.6.5.tar.gz
#WORKDIR /unrar
#RUN make -f makefile
#RUN install -v -m755 unrar /usr/bin

#WORKDIR /dense_flow/rars
#WORKDIR /dense_flow
#ADD a.rar /dense_flow/
#RUN unrar x hmdb51_org.rar rars/
#RUN for f in rars/*; do unrar x ${f} videos/; done;

### now let's test the of thing
#ADD bof.py ./
#RUN nvidia-smi
#RUN mkdir /dense_flow/my_of
#CMD ["python","bof.py","/dense_flow/videos","/dense_flow/my_of","--num_worker","2","--new_width","340","--new_height","256"]
#/dense_flow/build/extract_gpu -f videos/somersault/MWG_Bodenturnen_somersault_f_cm_np1_ri_bad_4.avi -x /dense_flow/my_of/flow_x -y /dense_flow/my_of/flow_y -i /dense_flow/my_of/img -b 20 -t 1 -d 0 -s 1 -o dir -w 340 -h 256

##this worked, but i think there is something fishy about the cuda code generation, so it doesn't work in the docker build stage, but works if we run this in the shell.
