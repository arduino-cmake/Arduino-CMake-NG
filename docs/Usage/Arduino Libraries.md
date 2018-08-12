One of Arduino's most important features, as with any development system, is its' libraries.
**Arduino-CMake** acknowledges it and attempts to make it as easy as possible for users to include libraries in their program, weather those are Arduino's built-in libraries or 3rd party libraries.
Users can also include **custom created libraries**, but since it's not considered an **Arduino Library**, it's documented in a different, appropriate page.

### Built-in Libraries

To include an Arduino library in your program, you should set the `ARDLIBS` variable in the generation function.
Let's look at an example:

```cmake
generate_arduino_firmware(${CMAKE_PROJECT_NAME}
        SRCS main.cpp
        ARDLIBS SoftwareSerial
        BOARD uno)
```

In the example above the **SoftwareSerial** library is included in the program and linked against the output firmware. It means you can include its header file in your program's file and use its structure.

You can specify unlimited number of libraries in the `ARDLIBS` variable as long as they are separated by spaces.

### 3rd Party Libraries

While Arduino's built-in libraries are sufficient in many cases, many other great 3rd party libraries are available out there. **Arduino-CMake** makes it easy to include those as well.

To include a custom/3rd part library you should:

1. Do One of the followings:
   1. Copy library's **containing directory** inside your project's directory
   2. Copy library's **containing directory** inside Arduino's built-in libraries directory, 
      located at `${ARDUINO_SDK_PATH}/libraries`
   3. Get library's **containing directory** path and call the `link_directories` function in your project's `CMakeLists.txt` file, passing it the acquired path
2. Set the `ARDLIBS` variable in the generation function to the name of the library

Let's look at an example where we want to simply reference a library located somewhere outside the scope of our project, named **Robotics**:

```cmake
link_libraries(/home/user/Downloads/libs/Robotics-avr-0.1.2)
generate_arduino_firmware(${CMAKE_PROJECT_NAME}
        SRCS main.cpp
        ARDLIBS Robotics-avr-0.1.2
        BOARD uno)
```

The example above actually shows an interesting point, where the name passed to the `ARDLIBS` parameter is actually the library's directory name, and not the name as we (Users) see it. 
This is because **Arduino-CMake** relates to libraries by their **containing directory**'s name.
In order to use the more-understandable name "**Robotics**", we need to rename the directory physically in the file system.

### Recursive Libraries

Some libraries, whether they are **Arduino** or **3rd party**, can have multiple levels of nesting inside their directory, leading to what **Arduino-CMake** defines as *recursive*.
In such cases, it is **vital** to explicitly define the library as *recursive*, by writing the following line **before** using the library in some *generation* function:

```cmake
set([LIB_NAME]_RECURSE True)
```

Where [LIB_NAME] is the name of library (More accurately - Its' parent directory's name).

An example of such library is the **Wire** built-in library, which defines the following directory structure:

```

```

