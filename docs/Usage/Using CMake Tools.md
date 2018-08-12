**CMake** can be used as an external tool (by default) or as a plugin in your IDE.
The default **CMake** tool actually encapsulates 2 tools in it:

1. `cmake` - Terminal tool used to invoke **CMake** commands from the command line
2. `cmake-gui` - GUI tool used to invoke **CMake** command using a graphical interface

Both provide the same functionality, however, the `cmake-gui` might be easier to operate most of the times.

### Using Terminal **CMake**

Since using the terminal version of **CMake**, `cmake`, is a bit more complicated, we've decided to list some common use cases regarding the **Arduino-CMake** project.

#### Including Toolchain

The simplest task that could be done with `cmake` to use **Arduino-CMake** is including its' toolchain file. 
You can accomplish that by executing `cmake -DCMAKE_TOOLCHAIN_FILE=[PATH_TO_TOOLCHAIN].cmake [PATH_TO_SOURCE_DIR]` in the terminal where:

* [PATH_TO_TOOLCHAIN] - Path to **Arduino-CMake**'s toolchain file
* [PATH_TO_SOURCE_DIR] - Path to the project's main directory

The same task can also be accomplished by setting a variable in the `CMakeLists.txt` file of the project.

> **Note:** We strongly recommend to prefer setting a variable in `CMakeLists.txt` instead of setting a build option in terminal since it's easily forgotten, leading to failing reloads or builds.

