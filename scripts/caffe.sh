#!/usr/bin/env bash

#i need to know the version of opencv to link this...
version="2.4.13"

#and this other STUFF
CAFFE_USE_MPI=${1:-OFF}
CAFFE_MPI_PREFIX=${MPI_PREFIX:-""}


# build caffe
echo "Building Caffe, MPI status: ${CAFFE_USE_MPI}"
cd lib/caffe-action
[[ -d build ]] || mkdir build
cd build
if [ "$CAFFE_USE_MPI" == "MPI_ON" ]; then
OpenCV_DIR=../../../3rd-party/opencv-$version/build/ cmake .. -DUSE_MPI=ON -DMPI_CXX_COMPILER="${CAFFE_MPI_PREFIX}/bin/mpicxx" -DCUDA_USE_STATIC_CUDA_RUNTIME=OFF
else
OpenCV_DIR=../../../3rd-party/opencv-$version/build/ cmake .. -DCUDA_USE_STATIC_CUDA_RUNTIME=OFF
fi
if make -j32 install ; then
    echo "Caffe Built."
    echo "All tools built. Happy experimenting!"
    cd ../../../
else
    echo "Failed to build Caffe. Please check the logs above."
    exit 1
fi
