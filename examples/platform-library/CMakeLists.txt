cmake_minimum_required(VERSION 3.8.2)

project(Platform_Library)
get_board_id(board_id nano atmega328)

add_arduino_executable(Platform_Library ${board_id} platformLibrary.cpp)

link_platform_library(Platform_Library Wire ${board_id})
link_platform_library(Platform_Library SPI ${board_id})
