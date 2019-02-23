cmake_minimum_required(VERSION 3.8.2)

#[[project(Knob_Example)
get_board_id(board_id nano atmega328)]]

arduino_cmake_project(Knob_Example BOARD_NAME nano BOARD_CPU atmega328)

find_arduino_library(servo_example_lib Servo)
add_arduino_library_example(Knob_Example servo_example_lib Servo Knob)
