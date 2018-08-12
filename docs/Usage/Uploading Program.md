As opposed to standard applications, Arduino "executables" can't just run on the host OS, and must be uploaded to a connected board.

To upload your program to the board, you should do several things:

1. Specify a port to upload to - That's where your board is connected to the system.
   The following examples show how to do it on **Linux** and **Windows**.

   **Linux:**

   ```cmake
   generate_arduino_firmware(${CMAKE_PROJECT_NAME}
           SRCS main.cpp
           BOARD uno
           PORT /dev/ttyACM0)
   ```

   **Windows:**

   ```cmake
   generate_arduino_firmware(${CMAKE_PROJECT_NAME}
           SRCS main.cpp
           BOARD uno
           PORT COM3)
   ```

2. Build the `${CMAKE_PROJECT_NAME}-upload` target created by executing `cmake`.
   **CMake** creates several targets that could be built, with the `Build-All` target as the default target.
   Building this target is sufficient for uploading, however, sometimes it's better to do this explicitly.

   Building the `upload` target on a valid port will result in the firmware being uploaded to the connected board, and will immediately run, just as it does with **Arduino IDE**.

### Uploading Multiple Targets

Users of **Arduino-CMake** can define several different firmware images for uploading in a single project, each defined to a different port connected to the PC.
To upload them all at once, you should build the `upload` target, or simply the default `Build-All`target as it builds all targets for all defined images. 

### Serial Ports on Different OSs

Each OS has its' own set of serial terminals, named differently.
Below is the list of known serial terminals on each supported OS:

#### Linux

On **Linux** the serial device/port is named as follows:

* `/dev/ttyUSBX`
* `/dev/ttyACMX`

Where `X` is the device number.

`/dev/ttyACMX` is used for new **Uno** and **Mega** Arduinos, while `/dev/ttyUSBX` for the old ones.

#### Mac OS X

Similar to **Linux**, there are 2 names for device/ports in **Mac**:

* `/dev/tty.usbmodemXXX`
* `/dev/tty.usbserialXXX`

Where `XXX` is the device ID.

`tty.usbmodemXXX` is used for new **Uno** and **Mega** Arduinos, while `tty.usbserialXXX` for the old ones.

#### Windows

**Windows** names all of its serial devices/ports as `COMx`, where `x` is the device number.