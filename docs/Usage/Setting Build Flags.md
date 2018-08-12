Since **Arduino-CMake** is kind of a build system for Arduino programs, it can also benefit from *build flags* to set the build's "tone". 

Build Flags modify the output of the build for specific purposes that usually don't exist by default.
CMake allows developers to define custom build flags by setting a special variable `CMAKE_[LANG]_FLAGS`, where [LANG] is the language you set the flags for (For example *C, CXX (C++), ...*).

There are 2 kinds of *build flags*: **Compile Flags** and **Linker Flags**

## Compiler Flags

These define the compiler's behavior, which in our case is `avr-gcc`.

### What can be defined?

To see the list of all possible flags that could be defined for this compiler, please see [avr-gcc's man page](https://gcc.gnu.org/onlinedocs/gcc/AVR-Options.html).

### Where to define?

Currently, the following variables can be defined:

* `ARDUINO_C_FLAGS` - C specific compiler flags
* `ARDUINO_CXX_FLAGS` - C++ specific compiler flags
* `ARDUINO_ASM_FLAGS` - Assembly specific compiler flags

You can set multiple variables if your project defined multiple programs in different languages, or you'd simply like to "mix" the flags to create a specialized build output.

If any of these variables is to be used, they **must** be defined *before* calling CMake's `project()` function, which defined the project's name and its languages.

### How to define?

Build flags are simply strings that have special meaning to the compiler at hand, meaning you can pass lots of them in a single build process.

To do that, you would write all desired flags inside quotes (`" "`) with a space between each flag.
For example, you can instruct the compiler to:

1. Ignore exception handling symbols
2. Disable hardware interrupts

By setting the following flags:

```cmake
set(ARDUINO_CXX_FLAGS "-fno-exceptions -mno-interrupts")
```

## Linker Flags

These define the linker's behavior, which in our case is `avr-ld`.

### What can be defined?

To see the list of all possible flags that could be defined for this compiler, please see [avr-ld's man page](http://ccrma.stanford.edu/planetccrma/man/man1/avr-ld.1.html).

### Where to define?

Same as for the [Compiler Flags](#Where-to-define?), except the variables.
For linker flags, the following variables are available:

* `ARDUINO_LINKER_FLAGS` - Linker's flags

### How to define?

Same as for the [Compiler Flags](#How-to-define?), linker flags are just strings.
The only main difference is that the flags are **not** separated by a space, but instead by a comma.

For example, you can instruct the linker to:

1. Enable indirect invocation by a compiler driver such as **gcc** (As is always used in **Arduino-CMake**)
2. Enable *garbage collection* of unused input sections.

By setting the following variables:

```cmake
set(ARDUINO_LINKER_FLAGS "-Wl,--gc-sections")
```

