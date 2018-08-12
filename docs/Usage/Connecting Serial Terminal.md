**Arduino-CMake** has the ability to connect the board through a *serial terminal*, just as you would with **Arduino IDE**.

To do that, you should pass the `SERIAL` parameter to the `generate_arduino_firmware` function.

The example below attempts to connect the board through the `picocom` serial interface:

```cmake
generate_arduino_firmware(${CMAKE_PROJECT_NAME}
      SRCS  main.cpp
      PORT  /dev/ttyUSB0
      SERIAL picocom [SERIAL_PORT] -b 9600 -l
      BOARD uno)
```

Where `[SERIAL_PORT]` is the port used for serial connection.

The example above will create a target named `${CMAKE_PROJECT_NAME}-serial` used specifically for connecting the program on the board through a serial terminal.

### Serial Terminals on Different OSs

Each OS has its' own set of serial terminals, named differently.
Below is the list of known serial terminals on each supported OS:

#### Linux

Linux has a variety of popular terminals that can be used. Below is a list of the most popular:

* **minicom**
* **picocom**
* **gtkterm**
* **screen**

In order to use one of them in **Arduino-CMake**, you should include the following line in your `CMakeLists.txt`:

```cmake
set(${FIRMWARE_NAME}_SERIAL [TERMINAL] [SERIAL_PORT])
```

Where:

* [TERMINAL] is the name of the serial terminal used
* [SERIAL_PORT] is the terminal device (Such as `/dev/tty.usbmodemXXX`)

#### Mac OS X

The easiest way to use a serial terminal in **Mac** is using the **screen** terminal emulator.

In order to use **screen** in **Arduino-CMake**, you should include the following line in your `CMakeLists.txt`:

```cmake
set(${FIRMWARE_NAME}_SERIAL screen [SERIAL_PORT])
```

Where [SERIAL_PORT] is the terminal device (Such as `/dev/tty.usbmodemXXX`).

#### Windows

The most popular serial terminal for **Windows** systems which has multiple purposes and supports a handful of protocols is [Putty](https://www.putty.org/).

In order to use **putty** in **Arduino-CMake**, you should add its' binary path to the `System Path`, then include the following line in your `CMakeLists.txt`:

```cmake
set(${FIRMWARE_NAME}_SERIAL putty -serial [SERIAL_PORT])
```

Where [SERIAL_PORT] is the terminal device.