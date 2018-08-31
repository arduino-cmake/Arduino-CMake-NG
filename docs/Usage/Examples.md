## Arduino Examples

One of Arduino SDK's most attractive features is examples.
Examples provide an easy way to learn Arduino programming, having the form of a complete, valid Arduino executable that could be uploaded to a hardware board.

### Overview

An Arduino Example consists of at least one source file, usually a sketch.

All SDK's built-in examples reside under the `${ARDUINO_SDK_PATH}/examples` directory.
Built-in examples are also divided into **Categories**, each prefixed with an indexing-number. e.g `01.Basics`.
The example itself is actually a directory named after the example, containing all other files required by an example. These directories reside under the matching **Category**.

For example, the **Blink** example has the following path: `${ARDUINO_SDK_PATH}/examples/01.Basics/Blink`
Inside this directory, there's `Blink.ino` - The example's sketch.

### Using Examples

To use an example one should call the `add_arduino_example` function.
It accepts the following parameters:

| Order | Name          | Description                                                  | Required? |
| ----- | ------------- | ------------------------------------------------------------ | --------- |
| 1st   | _target_name  | Target's name as it will be registered by CMake.             | Yes       |
| 2nd   | _board_id     | Hardware Board's ID as retrieved by the `get_board_id` function. | Yes       |
| 3rd   | _example_name | Name of the Arduino Example to use, case-insensitive. Name is expected to be a valid, existing example. | Yes       |
| -     | CATEGORY _cat | Name of the category the example belongs to. It helps optimizing the search process to find the example in the SDK. <br />Use only if name is accurate. | No        |

The example below shows how to use the **Blink** example:

```cmake
add_arduino_example(my_example_target_name ${board_id} Blink)
```

Assume that the board ID has been retrieved earlier and the executable target has already been created.

### Arduino Library Examples

Arduino libraries usually also have examples bundled with them, which are the same as Arduino Examples.
There are a few differences between the 2 though:

1. Arduino Library examples reside under the library's directory, usually under a sub-directory named **examples**.
2. A library example will have more than one source file most of the times.

Note that not all libraries have examples, and those that do can have more than one.

The **Servo** library for example defines an example named **Knob**, which has the following path: `${ARDUINO_SDK_PATH}/libraries/Servo/examples/Knob`

### Usage

Arduino library examples are used the same as "standard" examples, except they define a different function.
To use a library example, one should call the `add_arduino_library_example`, passing it the name of the library which the example belongs to and the example name itself.

The function accepts following parameters:

| Order | Name                  | Description                                                  |
| ----- | --------------------- | ------------------------------------------------------------ |
| 1st   | _target_name          | Target's name as it will be registered by CMake.             |
| 2nd   | _board_id             | Hardware Board's ID as retrieved by the `get_board_id` function. |
| 3rd   | _library_target_name  | Name of an existing target registered to the library the example belongs to. It means the library should first be found by calling `find_arduino_library`. |
| 4th   | _library_name         | Name of the library the example belongs to, case-insensitive. Name is expected to be a valid, existing example. |
| 5th   | _library_example_name | Name of the library example to use, case-insensitive. <br />Name is expected to be a valid, existing example. |

The example below shows how to use the **Knob** example of the **Servo** library:

```cmake
add_arduino_library_example(my_library_example_target Servo ${board_id} Knob)
```

Assume that the board ID has been retrieved earlier and the executable target has already been created.