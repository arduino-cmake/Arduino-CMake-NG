While programs/executables and libraries are sufficient in most cases, **Arduino** introduced the concept of **Sketches** which combines both into a single structure, usually even a single file.

For **Arduino-CMake**, **Sketches** are indeed a single file having the `.ino` or `.pde` extension.
Sketches are popular among **Arduino IDE** users especially since **Arduino-CMake** doesn't have the ability to create those - It treats all source files as standard **C++** files, usually having the `.cpp` extension.
In other words, sketch support exists mostly for compatibility issues, so that users of **Arduino IDE** won't have a hard time switching platforms.

From the above, we can infer that **Arduino Sketches** can only be *used*, not *created*.
Thus, we can only accept them as parameters to various **generation** functions, mostly the `generate_arduino_firmware` function.

So to include a sketch in your program, you should pass the sketch's parent directory path to the `SKETCH` parameter of the **generation** function.

For example, if you would like to include the built-in **Blink** sketch, you would do the following:

```cmake
set(blink_SKETCH  ${ARDUINO_SDK_PATH}/examples/1.Basics/Blink) # Path to sketch directory
set(blink_BOARD uno)

generate_arduino_firmware(blink)
```

This will create a perfectly valid target using either the `.ino` or `.pde` file existing inside the given directory.