## Arduino Examples

One of Arduino's most attractive features is its' great examples.
In order to easily learn how to use Arduino properly, it provides a lot of built-in examples in the form of a valid program - One that could be uploaded to the board.

**Arduino-CMake** acknowledges that and makes the process of using an example extremely easy to the user. But first, you should understand what *is* exactly an **Arduino Example**.

### What is it?

An **Arduino Example** is a standard Arduino program consisting of at least one source file.
Most common examples are the ones built-into Arduino, and also have a dedicated path.

All built-in examples reside under the `${ARDUINO_SDK_PATH}\examples` directory.
But this isn't sufficient, since there are **a lot** of examples out there.
All examples are divided into *Categories*, named with a prefixed indexing-number such as `01.Basics`.
Each *Category* lists all examples related to it in the form of directories - Where each directory contains the actual program's files.

For example, the most popular Arduino example of all times, **Blink**, has the following path:

`${ARDUINO_SDK_PATH}\examples\01.Basics\Blink` where it defines an `.ino` file as its'source file.

### How to use it?

Now that you have a solid knowledge of what is an **Arduino Example**, you can easily use it in **Arduino-CMake**.

To do so, you simply have to call the `generate_arduino_example` function, which accepts the following parameters:

| **Name**   | **Description****Description**           | **Is Required?**                |
| ---------- | ---------------------------------------- | ------------------------------- |
| BOARD      | Board name (such as *uno, mega2560, ...*) | Yes                             |
| BOARD_CPU  | Board CPU (such as *atmega328, atmega168, ...*) | Only if BOARD has multiple CPUs |
| EXAMPLE    | Example's name (such as *Blink*)         | Yes                             |
| CATEGORY   | Category name **without** prefixed index (such as *Basics*) | No                              |
| PORT       | Serial port for image uploading and serial communication | No                              |
| SERIAL     | Serial command for serial communication  | No                              |
| PROGRAMMER | Programmer ID to be burned to the board  | No                              |
| AFLAGS     | `avrdude` flags                          | No                              |

The example below shows how to create the **Blink** example in **Arduino-CMake**:

```cmake
generate_arduino_example(blink_example
		CATEGORY Basics
		EXAMPLE Blink
		BOARD uno)
```

In the example above, the `Category` parameter could be omitted, though it would cause a small performance penalty. Omitting `Category` causes **Arduino-CMake** to recursively search for the example through all existing *Categories*, which might take some time.

## Library Examples

As Arduino relies heavily on the use of libraries, it has also provided many examples on how to use them.
However, as those examples are library-specific, they're not part of the standard built-in examples.
In fact, each library has its own examples, nested under its containing directory.

The **Servo** library for example defines an example named **Knob**, which has the following path:

`${ARDUINO_SDK_PATH}\libraries\Servo\examples\Knob`

### How to use them?

Though it would seem natural to simply call the `generate_arduino_example` function with matching parameters, library-example generation is a bit different, requiring a separate function.
The `generate_arduino_library_example` has been defined for that, and accepts the following parameters:

| **Name**   | **Description**                          | **Is Required?**                |
| ---------- | ---------------------------------------- | ------------------------------- |
| BOARD      | Board name (such as *uno, mega2560, ...*) | Yes                             |
| BOARD_CPU  | Board CPU (such as *atmega328, atmega168, ...*) | Only if BOARD has multiple CPUs |
| LIBRARY    | Library's name (such as *Servo*)         | Yes                             |
| EXAMPLE    | Example's name (such as *Knob*)          | Yes                             |
| PORT       | Serial port for image uploading and serial communication | No                              |
| SERIAL     | Serial command for serial communication  | No                              |
| PROGRAMMER | Programmer ID to be burned to the board  | No                              |
| AFLAGS     | `avrdude` flags                          | No                              |

The example below shows how to generate the **Knob** example of the **Servo** library:

```cmake
generate_arduino_library_example(servo_knob_example
		LIBRARY Servo
		EXAMPLE Knob
		BOARD uno)
```

