cmake_minimum_required(VERSION 3.8.2)

project(Late_Source_Library)

get_board_id(board_id nano atmega328)

add_arduino_library(adafruit_NeoPixel_Late ${board_id})

add_arduino_executable(Late_Source_Library ${board_id} late-sources-lib.cpp)

target_sources(adafruit_NeoPixel_Late PUBLIC ${CMAKE_CURRENT_LIST_DIR}/Adafruit_NeoPixel/Adafruit_NeoPixel.cpp)
target_include_directories(adafruit_NeoPixel_Late PUBLIC Adafruit_NeoPixel)

link_arduino_library(Late_Source_Library adafruit_NeoPixel_Late ${board_id})
