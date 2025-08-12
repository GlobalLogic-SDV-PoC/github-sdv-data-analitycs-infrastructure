#!/bin/bash
# build.sh

# Exit on any error
set -e

# Build type
BUILD_TYPE=Debug

echo "Building service for Nvidia..."
mkdir -p build
cd build

# Configure CMake
cmake .. \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DCMAKE_INSTALL_PREFIX=install \
    -DBUILD_TESTING=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DSTATIC_STDLIB=ON \
    -DCMAKE_EXE_LINKER_FLAGS="-static-libstdc++ -static-libgcc"

# Build the application
cmake --build . --config $BUILD_TYPE -j$(nproc)

# Install the binaries
cmake --install .

echo "Nvidia build completed. Binaries are in ./build/"
