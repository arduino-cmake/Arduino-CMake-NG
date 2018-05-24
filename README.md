# Arduino-CMake

[![Travis Build Status](https://img.shields.io/travis/arduino-cmake/arduino-cmake.svg?logo=travis&style=for-the-badge&label=Linux&branch=master)](https://travis-ci.org/arduino-cmake/arduino-cmake) [![AppVeyor Build Status](https://img.shields.io/appveyor/ci/arduino-cmake/arduino-cmake/master.svg?logo=appveyor&style=for-the-badge&label=Windows)](https://ci.appveyor.com/project/arduino-cmake/arduino-cmake) [![Latest Release Version](https://img.shields.io/github/release/arduino-cmake/arduino-cmake.svg?logo=github&style=for-the-badge)](https://github.com/arduino-cmake/arduino-cmake/releases)

**Arduino-CMake** is a cmake-based *toolchain* which allows developers to build/compile and upload Arduino programs using any tool which supports cmake.
In other words, developers no longer need to use the **Arduino IDE** in order to write Arduino code, but instead can use their favorite IDEs or text editors!

## Motivation

The **Arduino IDE** lacks many features that are expected from a modern IDE or even a text editor.
However, it's the de-facto for developing Arduino programs. 

With **Arduino-CMake**, it doesn't have to be this way.

Arduino programs are built using `avr-gcc` - A derivative of the **gcc** compiler which makes it perfect for `make` files and thus **cmake**. Once built, it can be uploaded to a serial port over which the Arduino board is connected using `avr-dude`.
This is what allows **Arduino-CMake** to work out-of-the-box on *every* OS, in *every* IDE.

### Why is this a fork?

The original project has started back in 2011 by [queezythegreat](https://github.com/queezythegreat), and had been actively developed until 2014. Since then the project has been somewhat "dead" for 3 years, with various forks spreading over GitHub. Then, in 2017, a combined effort by [JonasProgrammer](https://github.com/JonasProgrammer) and [MrPointer](https://github.com/MrPointer) has brought new life to the project in the face of the [arduino-cmake organization](https://github.com/arduino-cmake). Since then, many great contributions has been made to the project, leading it to where it is today.

## Features

**Arduino-CMake** can do anything that the **Arduino IDE** can, *besides*:

* Supporting "big" platforms other than Arduino, such as **ESP**.

However, it allows some things that **Arduino IDE** doesn't:

* Developing Arduino code in any IDE or text editor
* Completely customizing the build process

Additionally, it's worth mentioning that **Arduino-CMake** is entirely cross platform.

## Code Example

A very basic example of how **Arduino-CMake** can be used is listed below:

```cmake
cmake_minimum_required(VERSION 2.8)
# Include Arduino-CMake Toolchain
set(CMAKE_TOOLCHAIN_FILE [ARDUINO_CMAKE_PATH]/ArduinoToolchain.cmake)
#====================================================================#
#  Setup Project                                                     #
#====================================================================#
project(MyProject C CXX ASM)

#====================================================================#
# Create Arduino's Executable
#====================================================================#
generate_arduino_firmware(${CMAKE_PROJECT_NAME}
        SRCS main.cpp
        BOARD uno
        PORT /dev/ttyACM0)
```

This is **cmake** code inside the `CMakeLists.txt` file of the `MyProject` project.

Very simple, yet super extensible.

## Installation

A complete installation guide can be found in the [Installation](https://github.com/arduino-cmake/arduino-cmake/wiki/Installation) Wiki page.

## Documentation

The entire documentation of the project is hosted on GitHub using [Wiki pages](https://github.com/arduino-cmake/arduino-cmake/wiki).

## Contributing

The project has strict contributing guidelines which can be found in the [Contributing File](https://github.com/arduino-cmake/arduino-cmake/blob/develop/CONTRIBUTING.md).

## License

MIT © 2018 [Arduino-CMake](https://github.com/arduino-cmake/arduino-cmake/blob/docs/LICENSE.md)