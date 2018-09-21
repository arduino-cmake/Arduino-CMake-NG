cmake_minimum_required(VERSION 3.8.2)

project(3rd_Party_Arduino_Library)
get_board_id(board_id nano atmega328)

add_arduino_executable(3rd_Party_Arduino_Library ${board_id} testNeoPixel.cpp testGFX.cpp)

add_arduino_library(Adafruit_NeoPixel ${board_id} libraries/Adafruit_NeoPixel/Adafruit_NeoPixel.cpp)
target_include_directories(Adafruit_NeoPixel PUBLIC libraries/Adafruit_NeoPixel)

# 'Trick' the framework to use current directory as Sketchbook, allowing us to use the 'find' API
set(ARDUINO_CMAKE_SKETCHBOOK_PATH "${CMAKE_CURRENT_LIST_DIR}")
find_arduino_library(Adafruit_GFX Adafruit-GFX-Library ${board_id} 3RD_PARTY)
target_source_directories(Adafruit_GFX
        DIRS libraries/Adafruit-GFX-Library/Fonts)

link_arduino_library(3rd_Party_Arduino_Library Adafruit_NeoPixel ${board_id})
link_arduino_library(3rd_Party_Arduino_Library Adafruit_GFX ${board_id})
