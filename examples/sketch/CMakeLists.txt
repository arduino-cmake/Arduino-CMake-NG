cmake_minimum_required(VERSION 3.8)

project(Sketch LANGUAGES C CXX ASM)
get_board_id(board_id nano atmega328)

add_arduino_executable(Sketch ${board_id})
target_sketches(Sketch ${board_id} sketch.ino)
