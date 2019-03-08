# Change Log

## Version 0.7

Major API improvements and changes, focusing on delivering a much better UX.  
This version forms a basis for many other important features still missing from the framework.

### Changes

* Every project now requires a call to a setup function named `arduino_cmake_project()`, 
which accepts the project's name and the hardware board associated with it 
(similar to `board_id`).
* Derived from the above, there's no more need to pass a `board_id` argument
to various API functions - They use the one passed to the setup function internally.
* Platform libraries (**SPI**, **Wire**, etc.) can now be treated as all 
Arduino libraries, i.e. found using `find_arduino_library` and then linked using `link_arduino_library`.  
Before that, a dedicated function named `link_platform_library` had to be called.

## Version 0.6.1

Several bug-fixes discovered in the latest v0.6 and some minor features.

### New Features

* Added ability to create Arduino libraries without specifying sources at the moment of creation.  
  It aligns well with CMake's `target_sources` API.

### Bug Fixes

* Fixed a potential regression bug on **ubuntu/debian** systems causing problems with the *CoreLib* creation.  

* Platform elements search has been updated to exclude system's **PATH** in order to avoid false path detection.  

* Fixed bug where platform libraries weren't using all of their sources.

## Version 0.6

This is a **BIG** version including numerous bug fixes, changes and even some new features.  
It mostly addressed *3rd Party Libraries*.

### New Features

* 3rd Party Arduino libraries can now be manually added from any path using the `add_arduino_library` function or automatically found using the `find_arduino_library` function.  
  To use the *find API*, the `3RD_PARTY` argument option should be passed to the function.

* Header-only Arduino libraries are now supported - They can be manually added using the `add_arduino_header_only_library` function or automatically found using the `find_arduino_library` function.  
  To use the *find API*, the`HEADER_ONLY` argument option should be pass to the function.

* Full Arduino IDE *Sketchbook* support - Libraries, examples and sketches can be optionally searched there as well.  
  The framework can also automatically find the *Sketchbook Location*, however, this is disabled by default, what also means that unless set otherwise, the framework ***doesn't search the sketchbook*** - This policy is set due to the unwanted dependency on the Arduino IDE for this feature to fully work.  
  Further information can be found in the documentation.
* Many improvements to the CI platforms **AppVeyor** and **Travis CI**, including:
  * Cached builds - Decreased build time significantly
  * Improved control-flow and readability

### Bug Fixes

* All functions that were expecting a theoretically "unlimited" list of sources to operate on, such as `add_arduino_executable`, `add_arduino_library` etc. couldn't parse more than one file which also was the first.
* The `Linux-Dist-Detection` module didn't check whether the required dependencies for the detection are installed.
* 3rd Party libraries that don't include a **library.properties** file couldn't be used.
* 3rd Party libraries have been renamed to an "Arduino-Compliant" name when attempting to find them using the `find_arduino_library` function, which renamed them to an invalid name.
* 3rd Party libraries that have been added using custom CMake logic (Calls to `add_library`) didn't get any of the build flags that every Arduino library has to have.
* The framework couldn't automatically find the Arduino SDK on OS X images.

### Changes

* Updated project's workflow model, which mostly modifies the development branch from now on to be the **master** branch, instead of **develop**. More can be read in the **CONTRIBUTING.md** file.

* The `Find-SDK` module now searches for the **version.txt** file under a sub-directory named **lib**, which resides directly under SDK's root path. This file's path is common across all OSs, unlike the previously searched **arduino** program.

* The `find_arduino_library` function now searches under the following paths:

  * `ARDUINO_SDK_LIBRARIES_PATH` - Usually the **libraries** directory under the SDK's root directory
  * *Sketchbook Location* - **Arduino IDE**'s *Sketchbook* path, storing all user-downloaded libraries
  * `CMAKE_CURRENT_SOURCE_DIRECTORY` - The directory in which the executed **CMakeLists.txt** file resides, i.e. Project's source directory
  * `PROJECT_SOURCE_DIR` - The directory in which the **CMakeLists.txt** file that sets the `project` resides.

  Besides,  the following sub-directories are searched under every path mentioned above:

  * **libraries**
  * **dependencies**

* 3rd Party Arduino Libraries do not longer have to include the **library.properties** file in their root directory - Their root directory is searched instead.  
  Nevertheless including the file is still ***recommended***, because when the file isn't present, the framework can't infer potentially required metadata from it.

## Version 0.5.2

This version adds case-insensitive support for examples, forgotten in the last version.  
Fixes a bug in Core-Lib target creation on Debian/Ubuntu systems, and adds support for **AppVeyor** CI.  

But most importantly - It changes the way users should supply a custom SDK location.

### New Features

* Example name parameter of the **Example API** functions is now case-insensitive
* Support for **AppVeyor** continuous integration/CI.

### Changes

* Supplying custom **Arduino SDK** path - Should now set an environment variable in the system named `ARDUINO_SDK_PATH`, instead of passing it as a variable to CMake through `-D`
* Parameter order in the `add_arduino_library_example` function - `_board_id` becomes 2nd

### Bug Fixes

* Potential bug in Debian/Ubuntu systems when creating Core Library targets

## Version 0.5.1

This version fixes some "invisible" bugs from previous versions, along with general design improvements.  
Moreover, there are even some new minor features.

### New Features

* Library name parameter of the `find_arduino_library` function is now case-insensitive due to a new utility feature to convert strings to *PascalCase*

### Changes

* Refactored many modules previously under the `Other` directory to be each under its' relevant directory

### Bug Fixes

* Sketch conversion was only partially avoided - Now the functionality is optimized
* Arduino libraries couldn't be linked to the target when resolving a sketch's headers
* Regex search patterns

## Version 0.5

This version refactored the Sketch API entirely to enhance support for missing features from previous versions. It also organized "*globals*"  and default options in a single 'Defaults' module.

### New Features

* Headers included in a sketch file are now resolved to provide better insight
  * Arduino/Platform libraries that are resolved from a sketch's headers are linked to the target
* Option/Policy to "forcefully" convert a sketch to a source file when adding it to a target, even if the source file already exists (Usually means that sketch has already been converted).  
  By default it's set to **OFF**.

### Changes

* New Sketch API which resembles CMake's target API - Use `target_sketches` as you would use `target_sources`
* Various inline search patterns and defaults have been moved to the 'DefaultsManager' module

## Version 0.4.1

This version adds minor feature improvements as well as complete sketch support.

### New Features

* Full sketch support in the API
  * Sketch targets can be created by calling the `add_sketch_target` function
* Ability to provide a custom main platform header by setting the `USE_CUSTOM_PLATFORM_HEADER` option on

## Version 0.4

This version mostly added support for examples and sketches.

### New Features

* Arduino examples such as **Blink** can now be used by calling the `add_arduino_example` function
* Arduino library examples, each being part of an Arduino library, can also be used by calling the `add_arduino_library_example` function
* Arduino Sketches can be converted into source files under the project's source directory.  
  The API to use them seamlessly as using examples is still missing, however.
* During platform initialization the main header of the platform gets selected.  
  This is useful for sketch conversion, as sketches usually don't include the header in their source files but depend on the **Arduino IDE** to do so instead.  
  The header is selected based on the number of `#include` lines it has - The header with most includes is selected as platform's main header, as it probably includes many other platform headers.

### Changes

* The API of the utility function `list_replace` now resembles CMake's List API.  
  It's also a macro now instead of a function.
* Improved logic and performance of utility `increment` and `decrement` math functions

## Version 0.3.1

This version includes a **critical** bug fix.

### Bug Fixes

* Wrong Core Library was used for libraries of the same board - As the Core-Lib is board-specific and board-dependent, it shouldn't be different for targets of the same board

## Version  0.3

This version added support for Arduino libraries and platform libraries.

### New Features

* Arduino libraries can be found by calling `find_arduino_library` and then linked to another target by calling `link_arduino_library`
  * The library search process is architecture-aware, meaning that only sources that match the platform's architecture will be included in the library target
* Arduino platform libraries can be simply linked to another target by calling `link_platform_library`.  
  There's no special search process for platform libraries as there is for Arduino libraries.

## Version 0.2

This version added support for the **Core Library** - A static library built from the platform's core sources that must be linked to every single target in the Arduino build system, including libraries in the future.  
This library is also the missing piece for getting correct program sizes, which hasn't been the case up until now.

### New Features

* The Core Library is added once per board (As a board has a single associated core) and linked against every created target.  
  This behavior is internal and not up to the control of the user, much like a Kernel.

### Changes

* The entire codebase has been "cleaned", code-wise. It includes:
  * Separation of Concerns - Everything has its' own function, preferably also a module (CMake file)
  * Better control flow
  * Better use of "Modern CMake" recommendations

## Version 0.1.1

This version added support for displaying a program's size upon build completion.

### New Features

* Program size output for every executable target at the end of each successful build.  
  This is done using Arduino's **avr-size** tool.  
  The tool's output is then reformatted to match the format of Arduino IDE.

## Version 0.1

This is the bare metal version of the framework, adding support for the very basic stuff.  
Although basic, there's a lot that had to be done in order to reach a somewhat "stable" version that can be burned to the board and actually work.

### Features

* Creating Arduino "executables" (Hex files that can be burned/uploaded/flashed to the hardware board) by calling `add_arduino_executable`
* Uploading created executables/targets to a connected hardware board by calling `upload_arduino_target`, passing it the Serial Port (Such as **COM3**) through which the uploading process will be done
* Analyzing the SDK by parsing all required information from files such as `platform.txt` and `boards.txt`
  * Parsing the `platform.txt` file is an entirely new concept that hasn't been used until now in all forks of the old Arduino-CMake. In fact, this is what allows the framework to be truly platform-agnostic, as it defines the platform's core behavior

Many more subtle and internal features have been implemented, but they won't be listed here.
