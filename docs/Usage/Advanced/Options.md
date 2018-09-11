Options in CMake are structures that represent boolean values, indicating whether something is `ON` or `OFF`.
The following table describes all the options supported by **Arduino-CMake**, and their meaning:

| Option Name                                  | Description                                                  | Default Value |
| -------------------------------------------- | ------------------------------------------------------------ | ------------- |
| USE_DEFAULT_PLATFORM_IF_NONE_SET             | Whether to use Arduino as default platform if none is manually set | ON            |
| USE_CUSTOM_PLATFORM_HEADER                   | Whether to expect and use a custom-supplied platform header, skipping the selection algorithm | OFF           |
| USE_ARCHLINUX_BUILTIN_SUPPORT                | Whether to use Arduino CMake's built-in support for the arch Linux distribution | ON            |
| CONVERT_SKETCHES_IF_CONVERTED_SOURCES_EXISTS | Whether to convert sketches to source files even if converted sources already exist - Force conversion | OFF           |

