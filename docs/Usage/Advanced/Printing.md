**Arduino-CMake** can print to the standard output many things that may be useful to some users, but mostly, just to do a "sanity-check" that the used platform is valid.

This feature is implemented through functions that could be called any time after the toolchain's initialization has completed. Here is the complete list of them:

* `print_board_list()` - Prints a list of all detected boards of the used platform
* `print_programmers_list()` - Prints a list of all detected programmers of the used platform
* `print_board_settings(BOARD_NAME)` - Prints the given board's settings such as its cpu, fuses, etc.
* `print_programmer_settings(PROGRAMMER_ID)` - Prints the given programmer's settings.