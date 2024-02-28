#include <Arduino.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>

void setup()
{
    pinMode(LED_BUILTIN, OUTPUT);
    SPIClass::setDataMode(0);
}

void loop()
{
    digitalWrite(LED_BUILTIN, HIGH); // turn the LED on (HIGH is the voltage level)
    delay(1000);                     // wait for a second
    digitalWrite(LED_BUILTIN, LOW);  // turn the LED off by making the voltage LOW
    delay(1000);                     // wait for a second
}
