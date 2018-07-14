#include <Ethernet.h>
#include <Servo.h>
#include <Stepper.h>
#include <Arduino.h>

Stepper stepper{1, 7, 6};
Servo servo;
EthernetClient client{};

void setup()
{
    stepper.version();
}

void loop()
{

}
