cmake_minimum_required(VERSION 3.8)

project(Blink_Example LANGUAGES C CXX ASM)

get_board_id(board_id nano atmega328)

add_arduino_example(Blink_Example ${board_id} Blink)
