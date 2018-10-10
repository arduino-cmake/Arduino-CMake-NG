cmake_minimum_required(VERSION 3.8.2)

project(Sketch)
get_board_id(board_id nano atmega328)

add_arduino_executable(Sketch ${board_id})
target_sketches(Sketch sketch1.ino sketch2.pde)
