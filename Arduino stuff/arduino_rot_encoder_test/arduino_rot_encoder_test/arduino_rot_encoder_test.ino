  
 /*
  Tomaso Muzzu - UCL - 25 May 2017
  Script to communicate with the following devices from Matlab:
  - rotary encoder with quadrature encoding of position. Model Kubler 05.2400.1122.1024 (READ)
  - pintch valve for water reward. Model NResearch 225P011-21 (WRITE)
  - lick detector based on IR beam breaking circuit. Model OP550 and IR26-21C-L110-TR8 (READ)
*/

#include <Event.h>
#include <Timer.h>

#define encoder0PinA 2        // sensor A of rotary encoder
#define encoder0PinB 13        // sensor B of rotary encoder


// variables for rotary encoder
volatile signed int encoder0Pos = 0;    // variable for counting ticks of rotary encoder
unsigned int tmp_Pos = 0;                 // variable for counting ticks of rotary encoder
boolean A_set;
boolean B_set;


void setup() {

  pinMode(encoder0PinA, INPUT);   // rotary encoder sensor A
  pinMode(encoder0PinB, INPUT);   // rotary encoder sensor B

  // interrupts for rotary encoder
  attachInterrupt(digitalPinToInterrupt(encoder0PinA), doEncoderA, CHANGE);
  // attachInterrupt(digitalPinToInterrupt(encoder0PinB), doEncoderB, CHANGE);

  Serial.begin (250000);
  Serial.setTimeout(5);

  delay(500);
}

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
void loop() {
  //Check for change in position and send to serial buffer
  // if (tmp_Pos != encoder0Pos) {
  //   Serial.print(encoder0Pos);//
  //   Serial.print("\n");
  //   tmp_Pos = encoder0Pos;
  // }
  // else {
  //   Serial.print(tmp_Pos);//
  //   Serial.print("\n");
  // }

  // delay(1);
}
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
// Interrupt on A changing state
void doEncoderA() {
  // Low to High transition?
  if (digitalRead(encoder0PinA) == HIGH) {
    B_set = digitalRead(encoder0PinB);
    if (B_set==HIGH) {
      encoder0Pos = 1;
    }
    else {
      encoder0Pos = - 1;
    }
    Serial.print(encoder0Pos);//
    Serial.print("\n");
  }
}




// EOF
