**Arduino-CMake** makes use of default variable values wherever it can, meaning the user has the ability to define its' own default.

The following variable can be set to define Arduino's SDK path:

* `ARDUINO_SDK_PATH` - Full path to the Arduino platform SDK

The following variables can be set to define defaults that affect Arduino-related generation process:

| Name                       | Description                              |
| -------------------------- | ---------------------------------------- |
| ARDUINO_DEFAULT_BOARD      | Default Arduino Board ID, when not specified |
|                            |                                          |
| ARDUINO_DEFAULT_PORT       | Default Arduino port, when not specified |
| ARDUINO_DEFAULT_SERIAL     | Default Arduino Serial command, when not specified |
| ARDUINO_DEFAULT_PROGRAMMER | Default Arduino Programmer ID, when not specified |

The following variables can be set to define defaults related to `avrdude`:

| Name                        | Description                              |
| --------------------------- | ---------------------------------------- |
| ARDUINO_AVRDUDE_PROGRAM     | Full path to `avrdude` programmer        |
| ARDUINO_AVRDUDE_CONFIG_PATH | Full path to `avrdude` configuration file |

### Internals Set By Arduino-CMake

Some variables are set internally by **Arduino-CMake**, allowing you to also make use of them later if needed to.

The list below describes some of these most common variables:

| Name                      | Description                              |
| ------------------------- | ---------------------------------------- |
| ARDUINO_FOUND             | Set to True when the **Arduino SDK** is detected and configured. |
| ARDUINO_SDK_VERSION       | Full version of the **Arduino SDK** (*ex: 1.8.4*) |
| ARDUINO_SDK_VERSION_MAJOR | Major version of the **Arduino SDK** (*ex: 1*) |
| ARDUINO_SDK_VERSION_MINOR | Minor version of the **Arduino SDK** (*ex: 8*) |
| ARDUINO_SDK_VERSION_PATCH | Patch version of the **Arduino SDK** (*ex: 4*) |

