It's important to understand that running CMake and build the project's binaries are 2 different things.

* Running CMake means to parse the project's CMake code to generate build files of some type.
  For example, one could use the **Unix Makefiles** generator and it would generate make-files.
* Building project's binaries means to build those generated files using the appropriate build tool, such as **make** if the files are make-files.

Every change in CMake code (which mostly happens in `CMakeLists.txt`) must be reloaded so that the latest code will be built. 
Some IDEs immediately inform you when there's a change in CMake so that you'll reload it.

A project depending on **Arduino-CMake** can be built by using either **make** or your IDE's **build tools**.
To see how it builds with **make**, please head to the [[appropriate page|Building-With-Make]].

