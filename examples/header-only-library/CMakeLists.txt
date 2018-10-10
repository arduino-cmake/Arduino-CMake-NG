cmake_minimum_required(VERSION 3.8.2)

project(Header_Only_Lib)
get_board_id(board_id nano atmega328)

add_arduino_executable(Header_Only_Lib ${board_id} headerOnlyTest.cpp)

# Find the library by 'tricking' the framework to use current directory as the Sketchbook path,
# allowing us to use the 'find' API
set(ARDUINO_CMAKE_SKETCHBOOK_PATH "${CMAKE_CURRENT_LIST_DIR}")
find_arduino_library(headerTest test-lib ${board_id} 3RD_PARTY HEADER_ONLY)

link_arduino_library(Header_Only_Lib headerTest HEADER_ONLY)
