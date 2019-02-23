cmake_minimum_required(VERSION 3.8.2)

#[[project(Platform_Library)
get_board_id(board_id nano atmega328)]]

arduino_cmake_project(Platform_Library BOARD_NAME nano BOARD_CPU atmega328)

add_arduino_executable(Platform_Library platformLibrary.cpp)

link_platform_library(Platform_Library Wire)
link_platform_library(Platform_Library SPI)
