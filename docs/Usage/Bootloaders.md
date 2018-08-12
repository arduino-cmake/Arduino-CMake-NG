Arduino enables developers not only to upload firmware images, but also *bootloader images*, which, basically, affect the way the board is working internally.

## What Is A Bootloader?

There are many ways to look at a bootloader, but the better one is probably as an *upload manager*.
Every Arduino board, or more accurately, an AVR microprocessor/chip, has a kind of a BIOS which affects how the board will operate when it's first booting up. This BIOS is called a *bootloader*.
Further information can be found in [Sparkfun's great tutorial on installing bootloaders](https://learn.sparkfun.com/tutorials/installing-an-arduino-bootloader).

### Customizing The Bootloader

Arduino boards enable developers to replace the default bootloader with their custom one.

Why would anyone need this? 
There are many reasons, one of them being that uploaded code would no longer be actually uploaded - The board may simply reject it. 
In this case, there is a slight chance that the bootloader got "screwed" up, and need to be replaced.

To install/burn a new bootloader you should use a programmer that allows it.
As this is page guides users on how to use bootloaders in **Arduino-CMake**, no further information on the burning process will be documented here. 
Instead, head to [Sparkfun's great tutorial on installing bootloaders](https://learn.sparkfun.com/tutorials/installing-an-arduino-bootloader).

## Bootloaders In Arduino-CMake

**Arduino-CMake** support bootloader burning and allows users to burn a custom bootloader using a programmer.
Many programmers are built-in the Arduino SDK, however, **Arduino-CMake** does not commits to fully support them all, at least not now.

Currently, the following programmers are supported:

| Programmer Name | Description         |
| --------------- | ------------------- |
| avrisp          | AVR ISP             |
| avrispmkii      | AVRISP mkII         |
| usbtinyisp      | USBtinyISP          |
| parallel        | Parallel Programmer |
| arduinoisp      | Arduino as ISP      |

### Burning a Bootloader

To burn a bootloader to a board you should:

1. Pass a `PROGRAMMER` parameter to the `generate_arduino_firmware` function
2. Build the `${TARGET_NAME}-burn` target where `TARGET_NAME` is usually the name of the project

This will burn/upload the generated *bootloader image* using the specified Programmer.

This topic is considered quite advanced and does not have a proper, clear example yet.

### Restoring Default Programmer

While using custom bootloaders for certain targets is perfectly valid, there may be a point in time where the custom bootloader is no longer needed, and Arduino's default bootloader should be restored.

This can be easily achieved by building the `${TARGET_NAME}-burn-bootloader` target while connected to to board, so it would also be burned/uploaded.
It will restore Arduino's default bootloader on the board.

> Note that a **programmer** should still be specified and connected in order to restore the default bootloader