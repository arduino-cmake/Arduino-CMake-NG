#include <Arduino.h>
#include <TestLib.hpp>

void setup()
{
    pinMode(BAR, OUTPUT);
}

void loop()
{
    foo();
    delayMicroseconds(SOME_DELAY);
}

void foo()
{
    digitalWrite(BAR, HIGH);
}
