cmake_minimum_required(VERSION 3.8)

project(Arduino_Library LANGUAGES C CXX ASM)
get_board_id(board_id nano atmega328)

add_arduino_executable(Arduino_Library ${board_id} test.cpp)

# Find and link the Stepper library
find_arduino_library(stepper_lib Stepper ${board_id})
link_arduino_library(Arduino_Library stepper_lib ${board_id})

# Find and link the Servo library - Custom implementation for many architectures, 
# 'avr' is used by default
find_arduino_library(servo_lib Servo ${board_id})
link_arduino_library(Arduino_Library servo_lib ${board_id})

# Find and link the Ethernet library - Depends on the SPI avr-platform library
find_arduino_library(ethernet_lib Ethernet ${board_id})
link_arduino_library(Arduino_Library ethernet_lib ${board_id})

#upload_arduino_target(Arduino_Library "${board_id}" COM3)
