cmake_minimum_required(VERSION 3.8)

project(Blink LANGUAGES C CXX ASM)

get_board_id(board_id nano atmega328)

add_arduino_executable(Blink "${board_id}" blink.cpp)
#upload_arduino_target(Blink "${board_id}" COM3)
