cmake_minimum_required(VERSION 3.8.2)

project(3rd_Party_Arduino_Library LANGUAGES C CXX ASM)
get_board_id(board_id nano atmega328)

add_arduino_executable(3rd_Party_Arduino_Library ${board_id} test.cpp)

add_arduino_library(Adafruit_NeoPixel_lib ${board_id} Adafruit_NeoPixel/Adafruit_NeoPixel.cpp)
target_include_directories(Adafruit_NeoPixel_lib PUBLIC Adafruit_NeoPixel)
link_arduino_library(3rd_Party_Arduino_Library Adafruit_NeoPixel_lib ${board_id})
