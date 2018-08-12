An Arduino-based platform is a combination of an SDK and some hardware specification.

While Arduino's default/built-in platform is considered the most popular platform, it's certainly not the only available out there. One such platform that became very popular lately is [ESP8266](https://en.wikipedia.org/wiki/ESP8266) and the entire **ESP**-family in general.

## Platforms In Arduino-CMake

**Arduino-CMake** attempts to support as many platforms as possible, so that users will have the ability to customize program development as they want to.

Unfortunately however, currently we do not support platforms that define their own `platform.txt` file as part of the SDK. This includes the **ESP** platforms.
Any other platform should be supported and work seamlessly.

Also, we allow to register only a single platform per project. This behavior may change in the future.

### What Is Considered A Valid Platform?

Even in a bright future where **Arduino-CMake** will support all kinds of platforms, there will be some standards which define what is and what isn't a valid platform.

A valid platform is one that has the following SDK structure:

```
PLATFORM_PATH/
    |-- bootloaders/
    |-- cores/
    |-- variants/
    |-- boards.txt
    |-- programmers.txt
```

#### Arduino-Based Platforms

There is a growing number of platforms which heavily depend on the default Arduino platform, in such a way that they simply don't define some of the required structure shown above, relying on Arduino's instead. Such a platform is **pinoccio.**

While these platforms should be supported since they combine 2 structures that are completely supported by **Arduino-CMake**, these structures *aren't* support as a "mix" between the two.
It means that registering a platform like **pinoccio** is currently *not supported*.
However, we are working a fix to that so it should be resolved in the upcoming versions.

### Registering A Platform

In order to register your custom platform, you should simply set its' path *before* including **Arduino-CMake**'s toolchain file. The path should be set on a special variable named `PLATFORM_PATH`.
In case your platform also has a different CPU architecture than `avr`, you should set that as well in a special variable named `PLATFORM_ARCHITECTURE`.

That's really it - You don't even have to copy the platform's SDK under the project's source directory to make it work.

### Customizing Registration Process

> **Note:** This is considered bad practice and should not be attempted to unless you know exactly what you're doing.

You can customize the entire platform registration process by writing your own script file.
In order to make **Arduino-CMake** use your file instead of its own, set the `CUSTOM_PLATFORM_REGISTRATION_SCRIPT` variable to the script file's path.

If you'd like to better understand how to implement such a script, take a look at `Platform/Initialization/RegisterSpecificHardwarePlatform.cmake` and `Platform/Initialization/LoadArduinoPlatformSettings.cmake`.