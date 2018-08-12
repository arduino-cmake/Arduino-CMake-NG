**Arduino-CMake** allows developers/users to create and use their own custom libraries that could be used later by other programs written with it. Those libraries are always **static**.

### Creating Custom Libraries

This is done by calling the `generate_arduino_library` function in the same way as you would call `generate_arduino_firmware` to create a "simple" Arduino program, except in this case it would create a **static library** that has the `.a` extension in its' output file.

The `generate_arduino_library` function can accept the following parameters:

| Name        | Description                              | Is Required?                    |
| ----------- | ---------------------------------------- | ------------------------------- |
| BOARD       | Board name *(such as uno, mega2560, ...)* | Yes                             |
| BOARD_CPU   | Board CPU *(such as atmega328, atmega168, ...)* | Only if BOARD has multiple CPUs |
| SRCS        | Source files                             | Yes                             |
| HDRS        | Header files                             | No                              |
| LIBS        | Libraries to link                        | No                              |
| NO_AUTOLIBS | Disable Arduino library detection *(Enabled by default)* | No                              |
| MANUAL      | Disable Arduino Core (enables pure AVR development) | No                              |

For example, let's assume we that we write an Arduino program to blink a LED at a specified time.
One way to do this is by creating a "**Time**" library which would handle all time-related stuff for us, and then include it in the main program and use it accordingly.
For the sake of simplicity, assume that the "**Time**" library consists only of 2 files:

1. `Time.h`
2. `Time.c`

To create a static library consisting of these files, we should write the following `CMakeLists.txt`:

```cmake
generate_arduino_library(Time
		HDRS Time.h
		SRCS Time.c
		BOARD uno)
```

Where **Board** is the Arduino board which we build the library for.

### Using Custom Libraries

To include a static library you should set the `LIBS` parameter of the generation function, **after** the library itself has been created/generated.

To proceed the example above shown in [Creating Static Libraries](#Creating-Static-Libraries), see the following cmake code used to include the custom created library in the main program:

```cmake
generate_arduino_firmware(${CMAKE_PROJECT_NAME}
        SRCS main.cpp
        LIBS Time
        BOARD uno)
```

