Creating a program or an *executable* is probably the most important thing in any programming context, and Arduino isn't different. 

> Some may refer to an Arduino executable as a *Firmware*, since that's the only code that lives on the board

Doing so in **Arduino-CMake** is quite easy, requiring just a call to a single function: `add_arduino_executable`.
The function has the nature of CMake-target functions, such as `add_executable` (Which creates an executable runnable by the host OS), so for those familiar with the syntax - It's practically the same.
It accepts the following parameters:

| Order | Name         | Description                                                  | Required? |
| ----- | ------------ | ------------------------------------------------------------ | --------- |
| 1st   | _target_name | Target's name as it will be registered by CMake.             | Yes       |
| 2nd   | _board_id    | Hardware Board's ID as retrieved by the `get_board_id` function. | Yes       |
| 3rd   | _srcs        | List of source files to include in the executable target.    | Yes       |

Let's look at an example which creates an executable/program consisting of 2 source files and a header:

```cmake
get_board_id(board_id uno)
add_arduino_executable(my_target_name ${board_id} my_source.cpp SomeClass.h SomeClass.cpp)
```

Note that a call to `get_board_id` is required to pass a valid `_board_id` to the function!
For those that aren't familiar with CMake - Also note how you can pass an infinite list of source files separated by a whitespace (Might be a line-feed as well as a space). This is because it's the last argument of the function.

The next step is to learn how to upload the executable to the hardware board - See [[Uploading Program]].