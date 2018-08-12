CMake generation, which occurs when a user *reloads* the cmake code, is the process that creates appropriate `make files` that could later be built by the build toolchain.

CMake generation is triggered by the user using one of the available cmake tools, which executes a set of shell-like commands specific for **cmake**.
To see how those tools can be used, please head to the [[Using CMake Tools]] page.

One of the aspects of **CMake Generation** is the generator it's using for the task.
There a variety of generators available, each having it's unique output `make file`.

### Windows Generators

The default generator on **Windows** systems is the **Visual Studio xx** generator, where `xx` is the version of **Visual Studio**. It's equivalent to the C++ versions supported by the **Microsoft Visual C++ Compiler**.
This generator creates **Visual Studio** solution files, which can later be used in the **Visual Studio** IDE and built by the **Microsoft Visual C++ Compiler**.

However, **Arduino-CMake** is built with a derivative of the **gcc** compiler, which is completely different, thus requiring users to use a different type of generator.

The following generators are the best to choose from when generating in **Windows**:

* `MSYS Makefiles` - Generates MSYS `make` files
* `Unix Makefiles` - Generates standard UNIX `make` files
* `MinGW Makefiles` - Generates MinGW `make` files (best fit for **Windows**).
* `CodeBlocks - Unix Makefiles` - Generates CodeBlocks project files (for the **CodeBlocks** IDE).
* `Eclipse CDT4 - Unix Makefiles` - Generates Eclipse CDT 4.0 project files (for the **Eclipse** IDE).

#### MinGW Generator

Even though it's probably the best choice of generator for **Windows** systems. it has a drawback which must be addressed before using it.

The MinGW generator encounters an error when the `sh.exe` binary exists in the `System Path`.
In order to solve this issue, you should do the following:

1. Remove `${ARDUINO_SDK_PATH}/hardware/tools/avr/utils/bin` from the `System Path`.

2. Generate the build system using CMake with the following option set:

   ```
   CMAKE_MAKE_PROGRAM=${ARDIUNO_SDK_PATH}/hardware/tools/avr/utils/bin/make.exe
   ```

Then cmake will be generated as expected.

#### Eclipse CDT4 Generator

Some IDEs, like **CLion**, use this generator by default even though they're not somehow relevant to the **Eclipse** IDE. There's no need to use a different generator in that case - The IDE magically makes it work