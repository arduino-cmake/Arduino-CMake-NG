cmake_minimum_required(VERSION 3.8.2)

project(3rd_Party_Arduino_Library)
get_board_id(board_id nano atmega328)

# First, declare and create our executable - It'll use 4 sources
add_arduino_executable(3rd_Party_Arduino_Library ${board_id} 3rd_party.cpp
        NeoPixelTest.cpp GFXTest.cpp LiquidCrystalTest.cpp)
target_include_directories(3rd_Party_Arduino_Library PRIVATE include)

# Add the "NeoPixel" library manually using the library addition API
add_arduino_library(adafruit_NeoPixel ${board_id} libraries/Adafruit_NeoPixel/Adafruit_NeoPixel.cpp)
target_include_directories(adafruit_NeoPixel PUBLIC libraries/Adafruit_NeoPixel)

# Find the "GFX" library - It's located under the 'libraries' sub-dir, which is a valid search path
find_arduino_library(adafruit_GFX Adafruit-GFX-Library ${board_id} 3RD_PARTY)
# We can also explicitly add additional directories to the target,
# as only root dir and 'src' and 'utility' sub-dirs are added by default
target_source_directories(adafruit_GFX DIRS libraries/Adafruit-GFX-Library/Fonts)

# We can even automatically find a library that doesn't have a properties file!
find_arduino_library(sky_writer Skywriter ${board_id} 3RD_PARTY)

# Libraries that have an inner-dependency on a platform library are also suported!
find_arduino_library(liquid_Crystal LiquidCrystal_I2C ${board_id} 3RD_PARTY)

# Link all libraries to our previously created target
link_arduino_library(3rd_Party_Arduino_Library adafruit_NeoPixel)
link_arduino_library(3rd_Party_Arduino_Library adafruit_GFX)
link_arduino_library(3rd_Party_Arduino_Library sky_writer)
link_arduino_library(3rd_Party_Arduino_Library liquid_Crystal)
