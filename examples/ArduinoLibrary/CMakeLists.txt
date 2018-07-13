cmake_minimum_required(VERSION 3.8)

project(ArduinoLib LANGUAGES C CXX ASM)
get_board_id(board_id nano atmega328)

add_arduino_executable(ArduinoLib ${board_id} test.cpp)

# Find and link the Stepper library
find_arduino_library(stepper_lib Stepper ${board_id})
link_arduino_library(ArduinoLib stepper_lib)

# Find and link the Servo library - Custom implementation for many architectures, 
# 'avr' is used by default
find_arduino_library(servo_lib Servo ${board_id})
link_arduino_library(ArduinoLib servo_lib)

# Find and link the Ethernet library - Depends on the SPI avr-platform library
find_arduino_library(ethernet_lib Ethernet ${board_id})
link_arduino_library(ArduinoLib ethernet_lib)

#upload_arduino_target(ArduinoLib "${board_id}" COM3)
