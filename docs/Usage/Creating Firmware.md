As you've probably seen in the "Creating You First Program" page, creating a program with **Arduino-CMake** usually means creating a *firmware image* from that program.

Arduino is a microcontroller, meaning it has no OS whatsoever, thus is can't run "standard" executables as would **Linux**, **Windows**, etc.
Instead, Arduino requires a whole firmware image to be burned to it every time it should run a new program. This makes the process of creating and burning a firmware image the most valuable to Arduino's build chain, and **Arduino-CMake** respects that well, very well.

> Note: Burning is equivalent to uploading in this context

Creating a firmware image for the program at hand is done by calling the `generate_arduino_firmware` function. This function accepts the following parameters:

| Name        | Description                              | Is Required?                    |
| ----------- | ---------------------------------------- | ------------------------------- |
| BOARD       | Board Name (such as *uno, mega2560, ...*) | Yes                             |
| BOARD_CPU   | Board CPU (such as *atmega328, atmega168, ...*) | Only if BOARD has multiple CPUs |
| SKETCH      | Sketch Path                              | Only if SRCS aren't specified   |
| SRCS        | Source Files                             | Only if SKETCH isn't specified  |
| HDRS        | Header files                             | No                              |
| LIBS        | Custom Libraries (Static)                | No                              |
| ARDLIBS     | Arduino Libraries                        | No                              |
| PORT        | Serial port for image uploading and serial communication | No                              |
| SERIAL      | Serial command for serial communication  | No                              |
| PROGRAMMER  | Programmer ID to be burned to the board  | No                              |
| AFLAGS      | `avrdude` flags                          | No                              |
| NO_AUTOLIBS | Disable Arduino library detection (*Enables by default*) | No                              |
| MANUAL      | Disables Arduino Core (*Enables pure AVR development*) | No                              |

Let's look at an example which creates a program consisting of 3 source files, a header and also includes the **SoftwareSerial** library:

```cmake
generate_arudino_firmware(${CMAKE_PROJECT_NAME}
		SRCS main.cpp buffer.cpp buffer_interuptter.cpp
		HDRS buffer.hpp
		ARDLIBS SoftwareSerial)
```

