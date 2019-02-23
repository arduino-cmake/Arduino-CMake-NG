cmake_minimum_required(VERSION 3.8.2)

#project(Hello_World)
#get_board_id(board_id nano atmega328)

arduino_cmake_project(Hello_World BOARD_NAME nano BOARD_CPU atmega328)

add_arduino_executable(Hello_World ${board_id} helloWorld.cpp)

#upload_arduino_target(Hello_World "${board_id}" COM3)
