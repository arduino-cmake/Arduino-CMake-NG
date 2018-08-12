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