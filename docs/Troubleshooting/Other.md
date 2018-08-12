This page refers to various issues that don't have any specific category.

### Error: attempt to use poisoned "SIG_USART0_RECV"

If you get the following error:

```
/usr/share/arduino/hardware/arduino/cores/arduino/HardwareSerial.cpp:91:41: error: attempt to use poisoned "SIG_USART0_RECV"
/usr/share/arduino/hardware/arduino/cores/arduino/HardwareSerial.cpp:101:15: error: attempt to use poisoned "SIG_USART0_RECV"
/usr/share/arduino/hardware/arduino/cores/arduino/HardwareSerial.cpp:132:15: error: attempt to use poisoned "SIG_USART1_RECV"
/usr/share/arduino/hardware/arduino/cores/arduino/HardwareSerial.cpp:145:15: error: attempt to use poisoned "SIG_USART2_RECV"
/usr/share/arduino/hardware/arduino/cores/arduino/HardwareSerial.cpp:158:15: error: attempt to use poisoned "SIG_USART3_RECV"

```

You probably recently upgraded **avr-libc** to the latest version, which has deprecated the use of these symbols. There is an [Arduino Patch](http://arduino.googlecode.com/issues/attachment?aid=9550004000&name=sig-patch.diff&token=R2RWB0LZXQi8OpPLsyAdnMATDNU%3A1351021269609) which fixes these error.
You can read more about this bug here: [Arduino Bug ISSUE 955](http://code.google.com/p/arduino/issues/detail?id=955).