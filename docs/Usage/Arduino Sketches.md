**Arduino** has introduced a concept named **Sketches** - Meta-Projects that combine both the source file(s) and any info about used libraries or platform headers into a single structure, usually even a single file (Having the `.pde` or `.ino` extension).

**Arduino-CMake** treats all source files as standard **C++** files (usually having the `.cpp` extension), as this is the nature of CMake. 
It means of course that Sketches can't be supported out-of-the-box in their natural form.
Nevertheless, **Arduino-CMake** does support sketches by converting them into `.cpp` source files, along with some extra missing information embedded in them.
The converted source files are created within the project's source directory as detected by CMake (If required, further info can be found at CMake docs), and are automatically added to the target that required them.
From the above, we can also infer that sketches can only be *used*, not *created*.

### Using Sketches

Sketches are used when creating [[Examples]], but can also be specified manually for a certain target.