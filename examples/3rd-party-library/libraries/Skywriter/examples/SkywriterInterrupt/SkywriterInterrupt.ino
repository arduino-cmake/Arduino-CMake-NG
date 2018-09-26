/*
Because interrupts vary from device to device, 
this example might not work out of the box for you.

Read: http://arduino.cc/en/Reference/attachInterrupt
and adjust the code for your device accordingly.

*/
#include <Wire.h>
#include <skywriter.h>

/*
 Pin 2 is 
   interrupt 0 on the Uno
   interrupt 0 on the Mega2560
   interrupt 1 on the Leonardo
   just referred to as pin 2 for Due
*/
#define PIN_TRFR  2
#define PIN_RESET 3

void setup() {
  Serial.begin(9600);
  while(!Serial){};  
  
  Skywriter.begin(PIN_TRFR, PIN_RESET);
  Skywriter.onTouch(touch);
  
  Serial.println("Hello world!");
  
  /* Set up the initial interrupt */
  attachInterrupt(PIN_TRFR,poll,FALLING); // Arduino Due
  //attachInterrupt(0,poll,FALLING); // Arduino Uno
  //attachInterrupt(1,poll,FALLING); // Arduino Leonardo
  
}

void poll(){
  /* It doesn't matter how heavy this interrupt
  handler is. It will *not* fire again until
  Skywriter has finished processing the new data
  and we have re-attached the interrupt. */
  
  /* Handle the new data */
  Skywriter.poll();
  
  /* Skywriter must twiddle PIN_TRFR to tell
  the hardware it's processing the new data.
  Interrupt needs re-attaching afterwards! */
  attachInterrupt(PIN_TRFR,poll,FALLING); // Arduino Due
  //attachInterrupt(0,poll,FALLING); // Arduino Uno
  //attachInterrupt(1,poll,FALLING); // Arduino Leonardo
}

void loop() {
  /* Do something in our loop! */
  Serial.println("I'm alive!");
  delay(1000);
}

void touch(unsigned char type){
  Serial.println("Got touch ");
  Serial.print(type,DEC);
  Serial.print('\n');
}
