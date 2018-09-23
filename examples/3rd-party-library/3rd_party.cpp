#include <Arduino.h>
#include "NeoPixelTest.hpp"
#include "GFXTest.h"
#include "InterruptTest.hpp"

void setup()
{
    testNeoPixel();
    testGFX();
    testEnableInterrupt();
}

void loop()
{

}