# Arduino-CMake NG

[![AppVeyor](https://img.shields.io/appveyor/ci/arduino-cmake/arduino-cmake-ng/develop.svg?label=Windows&logo=appveyor)](https://ci.appveyor.com/api/projects/status/github/arduino-cmake/arduino-cmake-ng?svg=true)[![Travis CI](https://img.shields.io/travis/arduino-cmake/Arduino-CMake-NG.svg?label=Linux%20and%20OS%20X&logo=travis)](https://travis-ci.org/arduino-cmake/Arduino-CMake-NG)

**Arduino-CMake** is a framework which allows developers to write Arduino-based programs using any tool that supports cmake. *Arduino-based*? There are many other frameworks out there built upon Arduino's base, such as ESP32, and **we support that**.
In other words, developers can use their favorite IDEs or text editors on their favorite OS to develop Arduino programs!

Wait - Hasn't it been possible all this time? Apparently not, as you'll find out by reading further.

## Motivation

Everyone has their favorite IDE or text editor, and would like to continue using it as long as they can.
Upon encountering a framework that doesn't support it - We get frustrated.
Unfortunately that's often the case with the Arduino framework, as it offers a custom toolchain that makes it uncomfortable to use outside the dedicated **Arduino IDE**.

**Arduino-CMake** solves it by creating a framework leveraging all of Arduino's features, including its' custom toolchain, by adding a single dependency - The **CMake** build system.

### Project Roots

The original project started back in 2011 by [queezythegreat](https://github.com/queezythegreat) and had been actively developed until 2014,  when it had been abandoned due to unknown reasons.
Since then more than 150 (!) forks have emerged, leading to a "chaos" in the Arduino-CMake sphere.
The most important moment however was in 2017, when a combined effort by [JonasProgrammer](https://github.com/JonasProgrammer) and [MrPointer](https://github.com/MrPointer) has brought new life to the project in the face of the [arduino-cmake organization](https://github.com/arduino-cmake).
And yet, it still had its own problems, leading once again to an abandoned state.

Then, in 2018, an extreme effort has been made and the project has been completely rewritten (mostly by [MrPointer](https://github.com/MrPointer)) with a few very clear goals in mind:

- **Platform-Independent** - The framework shouldn't assume it works only with the basic Arduino platform, as there are many others out there. Any platform that confront to the design of the basic Arduino SDK is appropriate for use. An example of such a platform is ESP32.
- **Modern CMake** - All previous projects/forks have been using the fairly old CMake 2.8. CMake itself has transitioned much from version 2 to 3, benefiting from a whole lot of new exciting features. Even the official package managers support CMake 3 versions, so there's no excuse to not use it.
- **Modern Arduino SDK** - The Arduino SDK, much like CMake, has also undergone several major changes during the years, especially with version 1.6. The Arduino SDK has only recently got stable, and that's why we recommend always having the latest version installed, although we do have some minimum requirements for the framework to even work. You can find them at the Requirements section.

### How it works

Arduino programs are simply C/C++ programs which take advantage of a framework which allows them to run on specific hardware devices. It means that those programs need to be compiled somehow.
Back in the "old days" developers used compilers such as **gcc** directly from the command line. Then came build-tools such as **make**. Then came **CMake**.
Most of the modern build systems today are managed by CMake and most of the modern IDEs know that and take advantage of it.
But what's really useful in CMake, at least regarding our Arduino world, is the ability to cross-compile with a  toolchain.
The Arduino SDK, which one usually downloads together with the Arduino IDE, is actually also a toolchain, as it includes the required compilation & linkage tools for cross-compiling.
Analyzing the SDK allows us to build a framework using this toolchain, and also all of Arduino's other cool features such as *libraries, examples*, etc.

### What is NG?

NG stands for "New Generation".
Inferred from the written above, it can easily be understood why the project has this name.
However, if you don't think this name is good enough or it confuses you - Feel free to propose a name of your own, we're open for offers :)

## Features

**Arduino-CMake** should do <u>anything</u> that the **Arduino IDE** can!
Why should? Because currently it's still WIP, meaning there are still some missing features.
Here's a list of features **already supported** by **Arduino-CMake**:

* Creating Arduino "Executables"/Programs
* Uploading programs to hardware boards
* Linking/Using Arduino libraries to programs
  * Linking/Using custom libraries to programs
* Creating Arduino example programs
  * Creating Arduino library example programs
* Attaching Arduino sketches to programs

Moreover, **Arduino-CMake** allows some things that **Arduino IDE** *doesn't*:

- Developing Arduino programs in any IDE or text editor
- Completely customizing the build process per user's requirements

It also worth mentioning that **Arduino-CMake** is **entirely <u>cross platform</u>**.

## Requirements

The following list is the basic requirements of the framework in order to use it:

* Windows, OS X or Linux (BSD support is currently unknown, use at your own risk)
* CMake Version 3.8 or Higher
* Arduino-Based SDK compatible with Arduino SDK Version:
  * 1.8.2 or Higher on **Microsoft Windows**
  * 1.6.10 or Higher on **Linux** and **Apple OS X**

## Usage

A very basic example of how **Arduino-CMake** can be used is listed below:

```cmake
# Define CMake's minimum version (must-do) and the project's name and supported languages
cmake_minimum_required(VERSION 3.8)
project(Hello_World LANGUAGES C CXX ASM)

# Call a framework utility function, passing it information about the hardware board that will
# be used - This function returns a structure known only to the framework
get_board_id(board_id nano atmega328)

# Create an executable suitable for the Arduino firmware using CMake-style target-creation
add_arduino_executable(Hello_World ${board_id} helloWorld.cpp)
# Upload the created target through a connected Serial Port (Where your board is connected to)
upload_arduino_target(Hello_World "${board_id}" COM3)
```

You should then call **CMake** (either through cmd, cmake-gui or an IDE if it supports that) passing it the argument `-DCMAKE_TOOLCHAIN_FILE=[project_path]/cmake/Arduino-Toolchain.cmake` where `[project_path]` is substituted by the project's full path. This is what allows cmake to use our framework.

That's it! It's super simple, yet super extensible :)

## Installation

A complete installation guide can be found in the [Installation](https://github.com/arduino-cmake/arduino-cmake/wiki/Installation) Wiki page.

## Documentation

The entire documentation of the project is hosted on GitHub using [Wiki pages](https://github.com/arduino-cmake/arduino-cmake/wiki).

## Contributing

The project has strict contributing guidelines which can be found in the [Contributing File](https://github.com/arduino-cmake/arduino-cmake/blob/develop/CONTRIBUTING.md).

## License

MIT © 2018 [Arduino-CMake](https://github.com/arduino-cmake/arduino-cmake/blob/docs/LICENSE.md)