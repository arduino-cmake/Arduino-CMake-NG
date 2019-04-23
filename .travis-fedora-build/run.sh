#!/bin/sh
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Arduino-Toolchain.cmake -DARDUINO_CMAKE_SKETCHBOOK_PATH=/root/Arduino ../examples/
make

