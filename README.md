#### Legacy version of denseflow (for GTX 580)


This version is using CUDA 6.5 with linux 14.04 and indigo.

get this with --recursive, to make sure the denseflow package is also downloaded. If you are not me, here this will break. This is because I set the submodules to use ssh keys. You will need to fork this and set up your own keys to have the same funcionality. Google github ssh keys and how to create them, it should be fairly straightforward.

#### Install docker and an old nvidia driver

I am using the nvidia driver 340.108, which is the latest that supports the GTX 580. You may want to lock this so it can't be updated (as in our case it will make the gpu stop working!)

    nvidia-smi

Should show you something like this:


    Mon Aug 10 18:49:50 2020       
    +------------------------------------------------------+                       
    | NVIDIA-SMI 340.108    Driver Version: 340.108        |                       
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |===============================+======================+======================|
    |   0  GeForce GTX 580     Off  | 0000:02:00.0     N/A |                  N/A |
    | 30%   39C    P8    N/A /  N/A |    589MiB /  3071MiB |     N/A      Default |
    +-------------------------------+----------------------+----------------------+

    +-----------------------------------------------------------------------------+
    | Compute processes:                                               GPU Memory |
    |  GPU       PID  Process name                                     Usage      |
    |=============================================================================|
    |    0            Not Supported                                               |
    +-----------------------------------------------------------------------------+


You also need to downgrade nvidia-docker2:

    sudo apt-get install -y libnvidia-container1=1.0.7-1 --allow-downgrades
    sudo apt-get install -y libnvidia-container-tools=1.0.7-1 --allow-downgrades
    sudo apt-get install -y nvidia-container-toolkit=1.0.5-1 --allow-downgrades
    sudo apt-get install -y nvidia-container-runtime=3.1.4-1 --allow-downgrades
    sudo apt-get install -y nvidia-docker2=2.2.2-1 --allow-downgrades

Old nvidia docker hellow world should be:

    docker run --gpus all --rm -it nvidia/cuda:6.5-devel bash

I am not sure if nvidia-smi is installed, I think not, but you can check cuda with `nvcc --version`

#### Getting the docker networking

There is a script which will build the docker and mount the catkin_ws. I did this so that editting was faster.

This docker seems pointless, but it is an opencv2 with ros that can use old gpus for some extra computation. There are plenty of things you can do with optical flows, like super resolution, fast object tracking, visual odometry and possibly more.
