#include "include/InterruptTest.hpp"

void handler_function()
{
    uint32_t interrupt_time = millis();
}

void testEnableInterrupt()
{
    enableInterrupt(BUTTON_PIN, handler_function, RISING);
}
