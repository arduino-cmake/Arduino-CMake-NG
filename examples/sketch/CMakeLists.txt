cmake_minimum_required(VERSION 3.8.2)

project(Sketch)

arduino_cmake_project(Sketch BOARD_NAME nano BOARD_CPU atmega328)

add_arduino_executable(Sketch)
target_sketches(Sketch sketch1.ino sketch2.pde)
