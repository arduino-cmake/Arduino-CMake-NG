CMake generation is the process that generates build-ready files that could later be built by the build toolchain. It occurs on every CMake run.
The process can be triggered directly by the user by running a cmake tool (such as cmake), or by the build toolchain when it detects changes in the source tree.

### Generators

The input of a generation process is the generator to use.
There's a variety of generators available, each having it's unique output type. 
For example, the **Unix Makefiles** generator will generate make-files, whereas the **Ninja** generator will generate ninja build files.

However, not all generators can be used on all OSs.
While technically it's still possible and the output will be valid and "buildable", some generators just don't make sense to use on such platforms as there's no supported toolchain available for that OS.
A good example is Microsoft Windows, as you'll read next.

#### Windows Generators

The default generator on Microsoft Windows is the **Visual Studio xx** generator, where `xx` is a version of **Visual Studio**. It's equivalent to the C++ versions supported by the **Microsoft Visual C++ Compiler**.
This generator creates **Visual Studio** solution files, which can later be used in the **Visual Studio** IDE and built by the **Microsoft Visual C++ Compiler**.

However, the Arduino toolchain is based on a derivative of the **gcc** compiler, which theoretically exists only for Unix systems. To use **gcc** on Windows, one should use toolchains like **MinGW**.

So to use the **Arduino-CMake** framework on Microsoft Windows, you'll need to be equipped with an appropriate toolchain and use one of the following generators:

* `MSYS Makefiles` - Generates MSYS `make` files
* `Unix Makefiles` - Generates standard UNIX `make` files
* `MinGW Makefiles` - Generates MinGW `make` files (best fit for **Windows**).
* `Ninja` - Generates ninja build files (Same as `MinGW Makefiles` but uses the **ninja** build tool instead)
* `CodeBlocks - Unix Makefiles` - Generates CodeBlocks project files (for the **CodeBlocks** IDE).
* `Eclipse CDT4 - Unix Makefiles` - Generates Eclipse CDT 4.0 project files (for the **Eclipse** IDE).

#### MinGW Generator

Even though it's probably the best generator to use on Microsoft Windows, it has a drawback which must be addressed before using it.

The MinGW generator encounters an error when the `sh.exe` binary exists in the `System Path`.
In order to solve this issue, you should do the following:

1. Remove `${ARDUINO_SDK_PATH}/hardware/tools/avr/utils/bin` from the `System Path`.

2. Run CMake with the following argument:

   ```
   -DCMAKE_MAKE_PROGRAM=${ARDIUNO_SDK_PATH}/hardware/tools/avr/utils/bin/make.exe
   ```

Then cmake will be generated as expected.
