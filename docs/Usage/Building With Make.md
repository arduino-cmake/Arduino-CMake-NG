**make** is a famous build tool used to build `makefiles`.
It is a part of **gnu**, specifically **gcc** (or **MinGW** if you're on Microsoft Windows), so you must have that installed first in order to use it.

The example below demonstrates how **make** can be used to build your project's binaries, along with creating a dedicated build directory and generating CMake:

```bash
mkdir build
cd build
cmake -GUnix-Makefiles ..
make
```

Where:

* `build` is a sub-directory under the project's main directory, created to store CMake's output/artifacts.
* The `cmake ..` command generates project's output (called on the project's main directory), which is actually `makefiles` used later by make.
* The `make` command builds the project using the `makefiles` in the `build` directory.

> Note: The example above is written for *nix systems, mostly Linux.
> Syntax on Microsoft Windows is similar, yet may differ at some points, depending on the terminal at hand.

For more info on the **make** tool please see [make docs](https://www.gnu.org/software/make/manual/make.html).