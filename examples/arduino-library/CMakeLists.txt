cmake_minimum_required(VERSION 3.8.2)

project(Arduino_Library)

arduino_cmake_project(Arduino_Library BOARD_NAME nano BOARD_CPU atmega328)

add_arduino_executable(Arduino_Library test.cpp)

# Find and link the Stepper library
find_arduino_library(stepper_lib stePpEr) # Library name is case-insensitive to the user
link_arduino_library(Arduino_Library stepper_lib)

# Find and link the Servo library - Custom implementation for many architectures, 
# 'avr' is used by default
find_arduino_library(servo_lib Servo)
link_arduino_library(Arduino_Library servo_lib)

# Find and link the Ethernet library - Depends on the SPI avr-platform library
find_arduino_library(ethernet_lib Ethernet)
link_arduino_library(Arduino_Library ethernet_lib)

#upload_arduino_target(Arduino_Library "" COM3)
