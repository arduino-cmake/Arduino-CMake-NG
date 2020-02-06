cmake_minimum_required(VERSION 3.8.2)

project(Platform_Library)

arduino_cmake_project(Platform_Library BOARD_NAME nano BOARD_CPU atmega328)

add_arduino_executable(Platform_Library platformLibrary.cpp)

find_arduino_library(wire Wire)
link_arduino_library(Platform_Library wire)

find_arduino_library(spi SPI)
link_arduino_library(Platform_Library spi)

find_arduino_library(sd SD)
link_arduino_library(Platform_Library sd)
