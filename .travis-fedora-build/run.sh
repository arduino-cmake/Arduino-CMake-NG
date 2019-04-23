#!/bin/sh
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Arduino-Toolchain.cmake -DAUTO_SET_SKETCHBOOK_PATH=ON ../examples/
make

