**make** is a famous build tool used to build `make files`, which also happens to be the output of CMake.
**make** is a part of **gnu**, specifically **gcc**, so you must have that installed in order to use it.

Below is an example of how to use **make** to build your project's binaries:

```bash
mkdir build
cd build
cmake ..
make
```

Where:

* `build` is a sub-directory under the project's main directory, created to store cmake's output/artifacts.
* The `cmake ..` command reloads the project (called on the project's main directory).
* The `make` command builds the project using the artifacts in the `build` directory.

> Note: The example above is written for *nix systems.
> Syntax on Windows systems is similar, yet may differ at some points.

For more info on the **make** tool please see [make docs](https://www.gnu.org/software/make/manual/make.html).