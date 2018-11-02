#i need to know the version of opencv to link this...

version="2.4.13"

echo "Building Dense Flow"
cd lib/dense_flow
[[ -d build ]] || mkdir build
cd build
OpenCV_DIR=../../../3rd-party/opencv-$version/build/ cmake .. -DCUDA_USE_STATIC_CUDA_RUNTIME=OFF \
-DWITH_CUDA=ON \
-D ENABLE_FAST_MATH=1 \
-D CUDA_FAST_MATH=1 \
-D WITH_CUBLAS=1 \
-DWITH_TBB=ON \
-DWITH_V4L=ON 
if make -j ; then
    echo "Dense Flow built."
else
    echo "Failed to build Dense Flow. Please check the logs above."
    exit 1
fi
