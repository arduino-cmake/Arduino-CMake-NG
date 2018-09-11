The CMake build system has many ways to set build flags (compiler and/or linker flags), which can help drive the build. However, we generally recommends not to do so. Why?

**Arduino-CMake** analyzes the platform's properties files internally, which usually specify the build flags that should be used in every build, as recommended by the platform's vendors (Arduino themselves when using the original Arduino platform).
Moreover, the build flags are often separated to flags per language, meaning that `.c` files don't get the same flags as `.cpp` flags.
What it means is that the framework already does all the heavy lifting for you, covering all recommended build flags - Users shouldn't modify those flags, nor add new ones, unless they really know what they're doing.

### Setting Custom Flags

**Warning:** Before reading this, **<u>please</u>** carefully read the **passage above**.

#### Compiler Flags

In modern CMake we set compiler flags on targets, not globally as it used to be.
To do so, we have number of ways:

1. Use CMake's `target_compile_options` function, passing it an existing target's name and a list of options, which are in fact build flags.
2. Combine `target_compile_options` with CMake's [generator expressions](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html) to set flags per language, just as **Arduino-CMake** does.

However, if you still desire to set flags globally, it can be done by forcefully setting the `CMAKE_[LANG]_BUILD_FLAGS` cache variable, where `LANG` is the specific language to set flags for.
e.g `set(CMAKE_[LANG]_BUILD_FLAGS "-g" CACHE STRING "" FORCE)`

#### Linker Flags

Despite CMake's modern way to set compile flags on specific targets, linker flags don't enjoy such feature.
To set linker flags, one should forcefully set the `CMAKE_EXE_LINKER_FLAGS` cache variable.
Since there can be only a single instance of linker flags, it's recommended to either leave them as set by **Arduino-CMake** (Platform's vendors more accurately) or use only a single executable target in the project.