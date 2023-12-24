// NOTES
// Close, but not quite accurate if you don't complete a movement. Look into updatePos() code.

// INCLUDES

#include "USB.h"
#include "USBHIDKeyboard.h"

// CONFIG

// #define DEBUG_SILLY
#define DEBUG_NORM

#define PIN_A SCK
#define PIN_B A0


// Showing state as 0000 000AB;
// Where A on is 0x02
// And B on is 0x01;
// Both on is 0x03;
// Going backwards is 0x0 0x1 0x

#define STATIONARY 0x00
#define CLOCKWISE_START 0x02
#define CLOCKWISE_FINISH 0x01
#define MOVEMENT_PARTIAL 0x03
#define MOVE_MIDDLE 0x3
#define COUNTER_CLOCKWISE_START 0x01
#define COUNTER_CLOCKWISE_FINISH 0x02

// GLOBAL

USBHIDKeyboard Keyboard;

uint8_t pinStatePrev = 0x00;
uint8_t pinState = 0x00;
bool moving = false;
uint8_t movingStart = STATIONARY;
int32_t lastPos = 0;
int32_t pos = 0;

void updatePinState() {
  pinStatePrev = pinState;
  pinState =  0x0
              | (digitalRead(PIN_A) << 1)
              | (digitalRead(PIN_B) << 0);
  
  #ifdef DEBUG_SILLY
    if(pinState != pinStatePrev) {
      // Status
      Serial.print("State");
      Serial.print(" A ");
      Serial.print((char)((pinState >> 1) & 1), DEC);
      Serial.print(" B ");
      Serial.print((char)((pinState >> 0) & 1), DEC);
      Serial.println();

      

      if(moving == false)
      Serial.print(">> ");
      Serial.print(pos, DEC);
      Serial.println();
    }
  #endif
}

void updatePos() {
  lastPos = pos;
  if(!moving) {
      if(pinState == CLOCKWISE_START) {
        moving = true;
      } else if(pinState == COUNTER_CLOCKWISE_START) {
        moving = true;
      } else if (pinState == STATIONARY) {
        moving = false;
      }
      movingStart = pinState;
    } else if(moving) {
      // if(pinState == CLOCKWISE_START) {
      //   pos++;
      // } else if(pinState == COUNTER_CLOCKWISE_START) {
      //   pos--;
      // } else if (pinState == STATIONARY) {
      //   moving = false;
      // }
      if(pinState == MOVEMENT_PARTIAL) {
      } else if(pinState == CLOCKWISE_FINISH && movingStart == CLOCKWISE_START) {
        pos++;
      } else if(pinState == COUNTER_CLOCKWISE_FINISH && movingStart == COUNTER_CLOCKWISE_START) {
        pos--;
      } else {
        moving = false;
        // TODO: maybe set movingState back if they went forward and backward? Or is that important for effective backings 
      }
    }
}

void sendKeys() {
  if(pos > lastPos) {
    // Undo: Cmd + Shift + Z
    Keyboard.press(KEY_LEFT_GUI);
    Keyboard.press(KEY_LEFT_SHIFT);
    Keyboard.write('z');
    Keyboard.releaseAll();
  } else if(pos < lastPos) {
    // Undo: Cmd + Z
    Keyboard.press(KEY_LEFT_GUI);
    Keyboard.write('z');
    Keyboard.releaseAll();
  }
}

void setup() {
  // put your setup code here, to run once:
  pinMode(PIN_A, INPUT);
  pinMode(PIN_B, INPUT);
  // Serial.begin(9600);
  Keyboard.begin();
  USB.begin();
}

void loop() {
  updatePinState();
  updatePos();
  // sendKeys();
}
