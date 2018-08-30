**Arduino** has introduced a concept named **Sketches** - Meta-Projects that combine both the source file(s) and any info about used libraries or platform headers into a single structure, usually even a single file (Having the `.pde` or `.ino` extension).

**Arduino-CMake** treats all source files as standard **C++** files (usually having the `.cpp` extension), as this is the nature of CMake. 
It means of course that Sketches can't be supported out-of-the-box in their natural form.
Nevertheless, **Arduino-CMake** **<u>does</u>** support sketches by converting them into `.cpp` source files, along with some extra missing information embedded in them.
The converted source files are created within the project's source directory as detected by CMake (If required, further info can be found at CMake docs), and are automatically added to the target that required them.
From the above, we can also infer that sketches can only be *used*, not *created*.

### Using Sketches

Sketches are used behind the scenes when working with [[Examples]], but can also be specified manually for a certain target.
To do so, one would first create a target, usually an executable, and then should call the `target_sketches` function, which accepts the following parameters:

| Order | Name          | Description                                                  |
| ----- | ------------- | ------------------------------------------------------------ |
| 1st   | _target_name  | An existing target's name.                                   |
| 2nd   | _board_id     | Hardware Board's ID as retrieved by the `get_board_id` function. |
| 3rd   | _sketch_files | List of paths to sketch files which their converted sources should be added to the given target. |

Let's see an example which adds 2 sketch files under our project's source directory to an executable target:

```cmake
add_arduino_executable(my_target_name ${_board_id} "") # Create an empty target
target_sketches(my_target_name ${_board_id} sketch1.ino sketch2.pde)
```

Assume that the board ID has been retrieved earlier and the executable target has already been created.

It's also important to note that the `target_sketches` API is really similar to CMake's `target_sources` API.

#### Skipping Sketch Conversion

The process of converting a sketch to a source can be lengthy in time, depending on the host PC, but more importantly - Will **override any changes** made to the converted source manually.
To avoid this, **Arduino-CMake** does 2 things:

1. Checks whether the converted source already exists - If it does, sketch isn't converted.
2. Exports a CMake-Option to the user named `CONVERT_SKETCHES_IF_CONVERTED_SOURCES_EXISTS` which controls whether sketches should always be converted to sources, even if those exists. By default this options is set to **OFF**.

### Header Resolving

Sketches are quite a complex structure since they may include headers outside the scope of the project, maybe even an Arduino library, without any meta-information about them - It's all managed by the Arduino IDE internally.
This makes things quite complicated for **Arduino-CMake**, as it must resolve those headers when adding a sketch to a target, providing the same functionality offered by Arduino IDE.

Indeed, there's a resolving process executed for each sketch that should be added to a target:

1. For a given sketch file - Iterate over all of its `#include` lines, extracting the header name (with extension such as `.h`).
2. If the iterated header name matches any Arduino/Platform library - Find and link it to the target.
3. Otherwise, validate the header is included in the target by searching for it in all of the target's include directories. If not found, a warning is displayed.