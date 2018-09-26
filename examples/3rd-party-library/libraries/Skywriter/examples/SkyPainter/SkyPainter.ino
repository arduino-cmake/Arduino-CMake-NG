/*
 SkyPainter
 An advanced example showing the SkyWriter board acting as a 3D paint input
 for a NeoPixel matrix.

 Paint in the air with your finger, X/Y translate as normal, and Z is colour!
*/
#include <Adafruit_NeoPixel.h>
#include <Wire.h>
#include <skywriter.h>

#define PIN 8          // Pin for NeoPixel matrix
#define PIN_TRFR  2    // TRFR Pin of Skywriter
#define PIN_RESET 3    // Reset Pin of Skywriter

Adafruit_NeoPixel Neopixel = Adafruit_NeoPixel(64, PIN, NEO_GRB + NEO_KHZ800);

unsigned long brightness = 50;
unsigned char color = 0;

long touch_timeout = 0;

/*
 Keep track of the minimum and maximum X, Y, Z values
 for on-the-fly calibration of finger-to-led relationship
*/
unsigned int max_x, max_y, max_z;
unsigned int min_x, min_y, min_z;

void setup() {
  min_x = 255;
  min_y = 255;
  min_z = 255;
  
  Serial.begin(9600);
  while(!Serial){};
  Serial.println("Hello world!");
  
  Neopixel.begin();
  Neopixel.setBrightness(brightness);
  Neopixel.show();
  
  Skywriter.begin(PIN_TRFR, PIN_RESET);
  Skywriter.onTouch(touch);
  
  // Track gestures for clearing the screen
  Skywriter.onGesture(gesture);
  Skywriter.onXYZ(xyz);
}

/*
 Poll from any updates form Skywriter
*/
void loop() {
  // Poll for any updates from Skywriter
  // And update the NeoPixel matrix
  Skywriter.poll();
  Neopixel.show();
  if( touch_timeout > 0 ) touch_timeout--;
}

/*
 Handle the XYZ updates, determine min/max
 values and scale them to fit the display
*/
void xyz(unsigned int x, unsigned int y, unsigned int z){
  if( touch_timeout > 0 ) return;
  
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
  
  char buf[18];
  sprintf(buf, "%05u:%05u:%05u", x, y, z);
  Serial.println(buf);
}

/*
 Flicking from West to East will clear
 the Matrix.
*/
void gesture(unsigned char type){
  Serial.println("Got gesture ");
  Serial.print(type,DEC);
  Serial.print('\n');
  
  if( type == SW_FLICK_WEST_EAST ){
     Neopixel.clear(); 
  }
}

/*
 Touching the center of Skywriter will switch
 to brightness control mode. Letting you
 adjust the brightness of the pixels.
*/
void touch(unsigned char type){
  Serial.println("Got touch ");
  Serial.print(type,DEC);
  Serial.print('\n');
  
  if( type == SW_TOUCH_CENTER ){
    touch_timeout = 100;
    Neopixel.setBrightness(map(Skywriter.x, min_x, max_x, 0, 255));
  }
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

