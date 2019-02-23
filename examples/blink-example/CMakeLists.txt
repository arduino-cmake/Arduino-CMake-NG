cmake_minimum_required(VERSION 3.8.2)

#[[project(Blink_Example)
get_board_id(board_id nano atmega328)]]

arduino_cmake_project(Blink_Example BOARD_NAME nano BOARD_CPU atmega328)

add_arduino_example(Blink_Example Blink)
