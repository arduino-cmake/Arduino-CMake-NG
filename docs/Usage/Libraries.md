One of Arduino's most important features, as with any development system, are libraries.
Arduino has 3 different types of libraries, which can be merged just to 2:

1. **Built-in Libraries** - Libraries included as part of the SDK or a custom platform.
   These libraries conform to a certain format/standard determined by Arduino. For that reason they're also called "**Arduino Libraries**" in the **Arduino-CMake** terminology.
   Besides, they consist of only sources - There are no pre-built binaries whatsoever.
2. **User Libraries** - Libraries that were created by users, either directly or as a 3rd party.
   These libraries don't have to conform to any standard. Although they can expose pre-built binaries, it's really not recommended to do so, but provide sources instead.

Some of you have already noticed that **Arduino-CMake** takes an approach similar to CMake itself regarding the targets API, that is of course to ease the use of the framework. 
Libraries are no different. How?
In general, to use a certain library in your CMake project you must follow the following procedure:

1. Either find the library or create it yourself.
   Finding a library *usually* means finding a pre-built binary matching the requirements of the host OS.
2. Link the library target to some other target.

> We've emphasized *usually* because as described earlier, Arduino libraries are almost always unbuilt sources. In our case, the library target will always be created and built by the project itself.

**Arduino-CMake** takes a similar approach.
The following passages relate to the different types of libraries and how to use them:

### Built-in/Arduino Libraries

These libraries have to be found at first, then linked to another target, preferably the executable target.
The following example shows how the **Stepper, Servo** and **Ethernet** libraries are included in a project:

```cmake
find_arduino_library(stepper_lib Stepper ${board_id})
link_arduino_library(my_target stepper_lib ${board_id})

find_arduino_library(servo_lib Servo ${board_id})
link_arduino_library(my_target servo_lib ${board_id})

find_arduino_library(ethernet_lib Ethernet ${board_id})
link_arduino_library(my_target ethernet_lib ${board_id})
```

Note that the example above assumes the `my_target` target has already been created earlier.
Also, board's ID has been retrieved as well.

### User/3rd Party Libraries

These libraries have to be found at fist as well, however, the search "process" is done manually by the user.
This is because there's nothing special that defines a user library, unlike Arduino Libraries. 
It's considered good practice to keep a user library's sources under the project's scope, especially if that library is created especially for the project. It also makes it easy to "find" it.

Once found, the library should be ***created***. As explained above, the library isn't found like an Arduino library, thus no library target is created.
Creating a library target is really straightforward since it requires just the CMake library API!
To create a library, one would call the `add_library` function. Further info can be found at the CMake docs.

Since the library is manually created using CMake's API, it also requires the user to manually specify include directories, so that other targets linking the library will have access to its' headers.
This is done by calling the `target_include_directories` function, passing the name of the library target created earlier with `add_library`, a `PUBLIC` scope (So it will have effect during linkage) and the header directories themselves.
e.g `target_include_directories(my_library_target PUBLIC include)` where `include` is the directory containing all public headers.

At last, the library target should be linked to an existing target, just as you would with an Arduino library.

The following is a list of common and recommended places where 3rd party libraries should be stored:

1. Inside the project's root directory, under a sub-directory named after the library.
   Example:

   ```
   |-Project Root
   	|-Library
   		|-include
   			|-Library.h
   		|-src
   			|-Library.c
   ```

2. Inside Arduino's built-in libraries directory, located at `${ARDUINO_SDK_PATH}/libraries`.
   **Warning:** This is recommended only for libraries that follow the Arduino library format/standard!

3. Inside the project's root directory, under a sun-directory named *dependencies* where all other 3rd party libraries are located.
   **Note:** This is recommended only for 3rd party libraries.

The following example shows how a 3rd party library named **Robotics** is included in the project:

```cmake
set(Robotics_lib_path ${CMAKE_SOURCE_DIR}/dependencies/Robotics-1.2)
add_library(Robotics_lib STATIC ${Robotics_lib_path}/src/Robotics.c)
target_include_directories(Robotics_lib PUBLIC ${Robotics_lib_path}/include)
link_arduino_library(my_target Robotics_lib ${board_id})
```

Where `${CMAKE_SOURCE_DIR}` is the parent directory of the project's main `CMakeLists.txt` file.
The directory structure of the example is as follows:

```
|-Project Root
	|-dependencies
		|-include
			|-Robotics.h
		|-src
			|-Robotics.c
	|-src
	|-CMakeLists.txt
```

Note that the example above assumes the `my_target` target has already been created earlier.
Also, board's ID has been retrieved as well.