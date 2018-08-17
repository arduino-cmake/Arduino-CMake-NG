As detailed in [[Generating CMake]], the project binaries are built using a **build tool** correspondent to the CMake generator used.

Each tool has its own usage so to fully utilize the tool at your hand please refer to its' documentation.
However, since **make** is the most popular tool at the moment (**ninja** is extremely recommended to use instead), our docs include a section dedicated to **make** - [[Building With Make]].

Although different, most of the tools can be executed from the command-line by simply executing their binary in the appropriate *working directory*. Where is that directory? Generally it's the build directory used by CMake to output generated files to.

### Uploading Program

Building the project is an important step but probably not the one with the most impact.

Unlike desktop applications, Arduino programs can't be run directly on the host PC, but intend to run on specific hardware boards instead.
To make that happen, an **"Upload"** process should occur, where the built program binary is uploaded/transferred to the hardware board, usually through a USB.

**Arduino-CMake** takes care of that by exposing an API for uploading the program.
It should be **<u>the last CMake instruction</u>** in the `CMakeLists.txt` file, **after** the instruction to create the program's executable. This instruction will initiate an upload process at the end of each build.
The complete docs on how to use the API can be found in [[Uploading Program]].