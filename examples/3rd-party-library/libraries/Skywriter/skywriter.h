#include <Wire.h>

#ifndef _SKYWRITER_H
#define _SKYWRITER_H

#define SW_ADDR 0x42

#define SW_HEADER_SIZE   4

#define SW_DATA_DSP      1 //0b0000000000000001
#define SW_DATA_GESTURE  1 << 1 //0b0000000000000010
#define SW_DATA_TOUCH    1 << 2 //0b0000000000000100
#define SW_DATA_AIRWHEEL 1 << 3 //0b0000000000001000
#define SW_DATA_XYZ      1 << 4 //0b0000000000010000

#define SW_SYSTEM_STATUS 0x15
#define SW_REQUEST_MSG   0x06
#define SW_FW_VERSION    0x83
#define SW_SET_RUNTIME   0xA2
#define SW_SENSOR_DATA   0x91

#define SW_PAYLOAD_HDR_CONFIGMASK  0 // 2 Bytes
#define SW_PAYLOAD_HDR_TS          2 // 1 Byte
#define SW_PAYLOAD_HDR_SYSINFO     3 // 1 Byte
#define SW_PAYLOAD_DSP_STATUS      4
#define SW_PAYLOAD_GESTURE         6  // 4 Bytes
#define SW_PAYLOAD_TOUCH           10 // 4 Bytes
#define SW_PAYLOAD_AIRWHEEL        14 // 2 Bytes
#define SW_PAYLOAD_X               16 // 2 bytes
#define SW_PAYLOAD_Y               18 // 2 bytes
#define SW_PAYLOAD_Z               20 // 2 bytes

#define SW_SYS_POSITION            1
#define SW_SYS_AIRWHEEL            1 << 1

/*
  Constants for identifying tap
*/
#define SW_DOUBLETAP_CENTER        0
#define SW_DOUBLETAP_EAST          1
#define SW_DOUBLETAP_NORTH         2
#define SW_DOUBLETAP_WEST          3
#define SW_DOUBLETAP_SOUTH         4
#define SW_TAP_CENTER              5
#define SW_TAP_EAST                6
#define SW_TAP_NORTH               7
#define SW_TAP_WEST                8
#define SW_TAP_SOUTH               9
#define SW_TOUCH_CENTER            10
#define SW_TOUCH_EAST              11
#define SW_TOUCH_NORTH             12
#define SW_TOUCH_WEST              13
#define SW_TOUCH_SOUTH             14

#define SW_GESTURE_GARBAGE         1
#define SW_FLICK_WEST_EAST         2
#define SW_FLICK_EAST_WEST         3
#define SW_FLICK_SOUTH_NORTH       4
#define SW_FLICK_NORTH_SOUTH       5
#define SW_CIRCLE_CLOCKWISE        6
#define SW_CIRCLE_CCLOCKWISE       7

class _SkyWriter 
{
  public:
    void begin(unsigned char pin_xfer, unsigned char pin_reset);
    void poll();
    void onTouch( void (*)(unsigned char) );
    void onAirwheel( void (*)(int) );
    void onGesture( void (*)(unsigned char) );
    void onXYZ( void (*)(unsigned int, unsigned int, unsigned int) );
    unsigned char last_gesture, last_touch;
    unsigned int  x, y, z;
    int rotation;
  private:
    void (*handle_touch)(unsigned char)   = NULL;
    void (*handle_airwheel)(int)    = NULL;
    void (*handle_gesture)(unsigned char) = NULL;
    void (*handle_xyz)(unsigned int, unsigned int, unsigned int);
    int lastrotation;
    unsigned char xfer, rst, addr;
    unsigned char command_buffer[32];
    void handle_sensor_data(unsigned char* data);
};

namespace { _SkyWriter Skywriter; }

#endif
