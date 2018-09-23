cmake_minimum_required(VERSION 3.8.2)

project(3rd_Party_Arduino_Library)
get_board_id(board_id nano atmega328)

# First, declare and create our executable - It'll use 4 sources
add_arduino_executable(3rd_Party_Arduino_Library ${board_id} 3rd_party.cpp
        NeoPixelTest.cpp GFXTest.cpp InterruptTest.cpp)
target_include_directories(3rd_Party_Arduino_Library PRIVATE include)

# Add the "NeoPixel" library manually using the library addition API
add_arduino_library(Adafruit_NeoPixel ${board_id} libraries/Adafruit_NeoPixel/Adafruit_NeoPixel.cpp)
target_include_directories(Adafruit_NeoPixel PUBLIC libraries/Adafruit_NeoPixel)

# Find the "GFX" library by 'tricking' the framework to use current directory as the Sketchbook path,
# allowing us to use the 'find' API
set(ARDUINO_CMAKE_SKETCHBOOK_PATH "${CMAKE_CURRENT_LIST_DIR}")
find_arduino_library(Adafruit_GFX Adafruit-GFX-Library ${board_id} 3RD_PARTY)
# We can also explicitly add additional directories to the target,
# as only root dir and 'src' sub-dir are added by default
target_source_directories(Adafruit_GFX DIRS libraries/Adafruit-GFX-Library/Fonts)

# Find the "EnableInterrupt" a header-only library
#find_arduino_library(enableInterrupt EnableInterrupt ${board_id} 3RD_PARTY)

# Link all libraries to our previously created target
link_arduino_library(3rd_Party_Arduino_Library Adafruit_NeoPixel ${board_id})
link_arduino_library(3rd_Party_Arduino_Library Adafruit_GFX ${board_id})
#link_arduino_library(3rd_Party_Arduino_Library enableInterrupt ${board_id})
