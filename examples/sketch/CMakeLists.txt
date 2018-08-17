cmake_minimum_required(VERSION 3.8)

project(Sketch LANGUAGES C CXX ASM)
get_board_id(board_id nano atmega328)

add_sketch_target(Sketch ${board_id} sketch.ino)
