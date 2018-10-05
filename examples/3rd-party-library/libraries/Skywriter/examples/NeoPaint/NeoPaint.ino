#include <Adafruit_NeoPixel.h>
#include <Wire.h>

#define PIN 8

Adafruit_NeoPixel Neopixel = Adafruit_NeoPixel(64, PIN, NEO_GRB + NEO_KHZ800);

unsigned long brightness = 50;
unsigned char color = 0;

// Include string names of gestures/touches for testing
//#define SKYWRITER_INC_DEBUG_STRINGS
#include "skywriter.h"

unsigned int max_x, max_y, max_z;
unsigned int min_x, min_y, min_z;

void setup() {
  Serial.begin(9600);
  while(!Serial){};
  Serial.println("Hello world!");
  
  Neopixel.begin();
  Neopixel.setBrightness(brightness);
  Neopixel.show(); // Initialize all pixels to 'off'
 
  
  Skywriter.begin(12, 13);
  Skywriter.onTouch(touch);
  //Skywriter.onAirwheel(airwheel);
  Skywriter.onGesture(gesture);
  Skywriter.onXYZ(xyz);
}

void loop() {
  Skywriter.poll();
  /*int x;
  for(x = 0; x < 64; x++){
   Neopixel.setPixelColor(x, Wheel(color)); 
  }*/
  Neopixel.show();
}

void xyz(unsigned int x, unsigned int y, unsigned int z){
  if (x < min_x) min_x = x;
  if (y < min_y) min_y = y;
  if (z < min_z) min_z = z;
  if (x > max_x) max_x = x;
  if (y > max_y) max_y = y;
  if (z > max_z) max_z = z;
  
  unsigned char pixel_x = map(x, min_x, max_x, 0, 7);
  unsigned char pixel_y = map(y, min_y, max_y, 0, 7);
  uint32_t color        = Wheel(map(z, min_z, max_z, 0, 255));
 
  
  Neopixel.setPixelColor(pixel_x*8 + pixel_y, color);
  
  char buf[64];
  sprintf(buf, "%05u:%05u:%05u gest:%02u touch:%02u", x, y, z, Skywriter.last_gesture, Skywriter.last_touch);
  Serial.println(buf);
}

void gesture(unsigned char type){
  Serial.println("Got gesture ");
  Serial.print(type,DEC);
  Serial.print('\n');
  
  if( type == SW_FLICK_WEST_EAST ){
     Neopixel.clear(); 
  }
}

void touch(unsigned char type){
  Serial.println("Got touch ");
  Serial.print(type,DEC);
  Serial.print('\n');
  
  if( type == SW_TOUCH_CENTER ){
    Neopixel.setBrightness(map(Skywriter.x, min_x, max_x, 0, 255));
    //color = map(Skywriter.y, min_y, max_y, 0, 255);
  }
  /*else if( type == SW_TOUCH_EAST ){
     Neopixel.setBrightness(0);
  }
  else if( type == SW_TOUCH_WEST ){
     Neopixel.setBrightness(255);
  }*/
}

void airwheel(int delta){
  Serial.println("Got airwheel ");
  Serial.print(delta);
  Serial.print('\n');
  
  brightness += (delta/100.0);
  Neopixel.setBrightness(brightness % 255);
}

uint32_t Wheel(byte WheelPos) {
  if(WheelPos < 85) {
   return Neopixel.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
  } else if(WheelPos < 170) {
   WheelPos -= 85;
   return Neopixel.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  } else {
   WheelPos -= 170;
   return Neopixel.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
}

