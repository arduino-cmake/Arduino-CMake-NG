cmake_minimum_required(VERSION 3.8.2)

project(Hello_World)

arduino_cmake_project(Hello_World BOARD_NAME uno)

add_arduino_executable(Hello_World helloWorld.cpp)

set_target_upload_port(Hello_World COM3)
