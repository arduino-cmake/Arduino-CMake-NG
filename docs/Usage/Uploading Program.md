After creating the program/executable, one would probably upload it to a specific hardware board.
To upload a program in **Arduino-CMake** you should do several things:

1. Find the port where the system thinks your board is connected to, such as `COMx` on Microsoft Windows or `/dev/ttyACMx` on Linux.

2. Call the `upload_arduino_target` function. 

   > Although the target is always an executable, theoretically the function supports every CMake target.

   The function accepts the following parameters:

   | Order | Name         | Description                                                  | Required? |
   | ----- | ------------ | ------------------------------------------------------------ | --------- |
   | 1st   | _target_name | Name of the executable target to upload                      | Yes       |
   | 2nd   | _board_id    | Hardware Board's ID as retrieved by the `get_board_id` function. | Yes       |
   | 3rd   | _port        | Hardware board's port as identified in step 1                | Yes       |

Now let's see some examples of how to use it on different OSs, using the info above:

**Linux:**

```cmake
upload_arduino_target(my_target_name "${board_id}" /dev/ttyACM0)
```

**Windows:**

```cmake
upload_arduino_target(my_target_name "${board_id}" COM3)
```
Assume that the board ID has been retrieved earlier and the executable target has already been created.

### Uploading Multiple Targets

**Arduino-CMake** allows uploading multiple targets simultaneously from a single project due to the scripted nature of CMake.
This can be done by creating multiple executable targets, then uploading each to a different port.
It can be useful for example to upload both **Client** and **Server** programs to separate boards in one go.

### Serial Ports on Different OSs

Each OS has its' own set of serial terminals, named differently.
Below is the list of known serial terminals on each supported OS:

#### Linux

On Linux the serial device/port is named as follows:

* `/dev/ttyUSBX`
* `/dev/ttyACMX`

Where `X` is the device number.

`/dev/ttyACMX` is used for new **Uno** and **Mega** Arduinos, while `/dev/ttyUSBX` for the old ones.

#### Mac OS X

Similar to Linux, there are 2 names for device/ports in Mac:

* `/dev/tty.usbmodemXXX`
* `/dev/tty.usbserialXXX`

Where `XXX` is the device ID.

`tty.usbmodemXXX` is used for new **Uno** and **Mega** Arduinos, while `tty.usbserialXXX` for the old ones.

#### Microsoft Windows

Microsoft Windows names all of its serial devices/ports as `COMx`, where `x` is the device number.