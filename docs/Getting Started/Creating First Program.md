Creating a program with **Arduino-CMake** is ridiculously easy. 

First make sure you've fulfilled the requirements for your OS by installing all necessary programs.
Then download the source/assets and extract them to a directory on your file system.

It's important to understand that **Arduino-CMake** is simply a CMake toolchain.
What that means to the user is that it should only include a single `.cmake` file in order to use the framework. 
However, the framework itself is not that simple and consists of many additional CMake scripts required for it to work, so to fully setup the toolchain you should do one of the followings:

* Copy the directory extracted earlier to your project's directory
* Have the path (absolute or relative) to the extracted directory "at hand"

Then, you should create a `CMakeLists.txt` file in your project's main directory.
A simple example of such file could be:

```cmake
# Define CMake's minimum version (must-do) and the project's name and supported languages
cmake_minimum_required(VERSION 3.8)
project(Hello_World LANGUAGES C CXX ASM)

# Call a framework utility function, passing it information about the hardware board that will
# be used - This function returns a structure known only to the framework
get_board_id(board_id [BOARD])

# Create an executable suitable for the Arduino firmware using CMake-style target-creation
add_arduino_executable(Hello_World ${board_id} helloWorld.cpp)
# Upload the created target through a connected Serial Port (Where your board is connected to)
upload_arduino_target(Hello_World "${board_id}" [PORT])
```

Where:

* `helloWorld.cpp` is a **C++** source file which looks exactly like the main `.ini` file used by **Arduino IDE**.
* `[BOARD]` is the name of the Arduino board used to run the program.
* `[PORT]` is the port at which your Arduino micro-controller is connected to accept uploads.

Next step is to run cmake, passing it the following argument: `-DCMAKE_TOOLCHAIN_FILE=[ARDUINO_CMAKE_PATH]/Arduino-Toolchain.cmake`.
`[ARDUINO_CMAKE_PATH]` is the path to the framework's directory (Absolute or Relative).

More information on CMake and how to run it is available in the [[Using CMake Tools]] section.

Running CMake has generated build-ready output, so the only thing's left is to actually build it.
For this you'll use a tool compliant with the generator you've ran CMake with, like **make** if your generator was **Unix Makefiles**.
Building the project can be as simple as calling **make** from the project's binary directory using a cmd, clicking a 'Build' button in the IDE, or something more complicated - depending on your tool of choice.

Once built, the program might also be uploaded to the connected hardware board - Depending on whether a call to the `upload_arduino_target` function exists.
If it doesn't, the program will simply be built, creating the appropriate `.hex` file.

**That's it!**