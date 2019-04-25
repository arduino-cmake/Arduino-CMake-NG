#include <HardwareSerial.h>

int x = 5;

int bar(short, int b);

void foo()
{
    Serial.print(x);
    bar(5, 6);
}
