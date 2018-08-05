cmake_minimum_required(VERSION 3.8)

project(Knob_Example LANGUAGES C CXX ASM)

get_board_id(board_id nano atmega328)

find_arduino_library(servo_example_lib Servo ${board_id})
add_arduino_library_example(Knob_Example servo_example_lib Servo ${board_id} Knob)

