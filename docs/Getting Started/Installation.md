Suggested by its' name, **Arduino-CMake** requires **Arduino** and **CMake** to be installed on your system.
There may be additional requirements depending on your OS of choice.

Listed below are the steps required to install **Arduino-CMake** for each supported OS:

### Linux

Manually install the following packages, preferably with your package manager:

*  `gcc-avr` - AVR GNU GCC compiler
*  `binutils-avr` - AVR binary tools
*  `avr-libc` - AVR C library
*  `avrdude` - Firmware uploader

Then, download and install the [Arduino SDK](https://www.arduino.cc/en/Main/Software).
It's considered best practice to install it to `/usr/share` as this is where **Arduino-CMake** looks for it by default, however, it is not mandatory.

At last, install [CMake](https://cmake.org/download/) if it's not already installed.

### OS X

Though similar to **Linux** since it's also a *nix system, installing **Arduino-CMake** on **Mac** is much easier.
The **Arduino SDK** bundles everything required to setup the environment, including the toolchains.

Start with downloading the [Arduino SDK](https://www.arduino.cc/en/Main/Software) and copying it to `Applications`.
Then, also install the `FTDIUSBSerial` (for FTDI USB Serial) driver.

Now download **CMake** if it's not already installed, and install `cmake-*.pkg`.

> Note: Make sure to click on `Install Command Line Links`

### Windows

First, download and install the [Arduino SDK](https://www.arduino.cc/en/Main/Software). 
It's considered best practice to install it to `Program Files` as suggested by the installer as this is where **Arduino-CMake** searches for it by default, however, it is not mandatory.

Next, install [CMake](https://cmake.org/download/) if it's not already installed.

At last you need to make sure you have a build tool to build cmake's generated output with, such as **make**.
Most of these tools belong to the GNU and work only on Linux, but ports to Windows are available as well.
So, for example, if your build tool is **make**, it will require you to install either:

1. MinGW
2. Cygwin

If you're not familiar with these, they are ports of the **GNU Make** toolchain for the Windows OS (Cygwin is a lot more than that but it doesn't matter in this context).

**Note:** Make sure to add **make** to the system's path, otherwise you'll have trouble building programs.

### Preparing Environment

After installing all required prerequisites as described in the sections above, you should ensure your environment is ready for **Arduino-CMake**.

#### Arduino SDK Path

Assuming you've already set required paths (such as **gcc** or **MinGW**) in the environmental variable `PATH`, the next thing you must do is to find the path of the Arduino SDK.
By default, **Arduino-CMake** looks for the Arduino SDK in the following paths, divided by OSs:

##### Linux

* `/usr/share/arduino*`
* `/opt/local/arduino*`
* `/opt/arduino*`
* `/usr/local/share/arduino*`

##### OS X/MacOS

* `~/Applications`
* `/Applications`
* `/Developer/Applications`
* `/sw`
* `/opt/local`

##### Windows

* `C:/Program Files (x86)/Arduino`
* `C:/Program Files/Arduino`

##### Setting Custom Path

If your SDK isn't located in any of the above paths, you should pass it manually to the framework.
The framework stores the path in a cache variable named `ARDUINO_SDK_PATH`.
There are multiple ways to set this variable:

1. Pass the variable when running CMake, like this: `cmake -DARDUINO_SDK_PATH=[PATH]` where `[PATH]` is the absolute path to the SDK. **This is the preferred way!**
2. Set it manually in your main **CMakeLists.txt** file, like this: `set(ARDUINO_SDK_PATH "PATH")` where `PATH` is the absolute path to the SDK. Note that this line should appear **before** the line setting the project, which looks like `project(my_project)`.