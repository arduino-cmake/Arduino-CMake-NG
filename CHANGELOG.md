# Change Log

# Version [2.0.1](https://github.com/arduino-cmake/arduino-cmake/compare/v2.0.0...v2.0.1) (Dec 19th 2017)

### Bug fixes

* fixed `-DARDUINO` define for Arduino SDK versions between 1.0.0 and 1.5.8. This bug caused to included `WProgram.h` instead of `Arduino.h` for aforementioned versions.

# Version 2.0.0 (Dec 13th 2017)

An epic version which integrates too many changes to be listed and recorded since the latest stable version, which was **1.0.0**. It has been released almost <u>4 years ago</u>!

However, here are some of the most noticeable changes in this version:

* Code has been completely refactored:
  * Previously the project has consisted from generally 2 files:
    1. `ArduinoToolchain.cmake`
    2. `Platform/Arduino.cmake`
  * All functions and scripts in the `Arduino.cmake` file, which took nearly 3,500 lines of code, have been separated into matching script files, located under matching directories.
  * A script-driven approach has been taken, allowing developers to substitute a functionality simply by referencing a different CMake script file.
* Arduino SDK version 1.5 and higher is supported:
  * Several changes were introduced in the SDK itself causing the previous version to fail building.
* Custom hardware platforms and architectures can be defined:
  * Though it has already existed in the previous version, this feature was in a form of a function.
    Now it's a script that can either be replaced or use customized parameters.
  * Ability to define architecture is new.
* Example generation:
  * Users can generate firmware using one of Arduino's built-in examples, such as the classic **Blink**.
  * Support for example *categories* has also been added, complying with Arduino current example-nesting strategy. For example, the **Blink** example is located under the `01.Basic` directory, which is also considered as its category.