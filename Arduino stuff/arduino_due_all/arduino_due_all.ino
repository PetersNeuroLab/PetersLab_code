#include "sq_wave.h"
#include "trp_wave.h"


volatile int i = 0;
volatile int j = 0;

const int goPin = 0; // pin for experiment

const int SValvePin = 6; 

const int cameraOutPin = 2;

const int cameraInPin = 3;       // pin for "all lines exposing"
const int blueOutPin = 4;        // pin for blue's Gate1
const int violetOutPin = 5;      // pin for purple's Gate1
const uint8_t rampLightPin = DAC1;  // pin for ramping light

int flipflopState = 0;        
int lastPCOstate = 0;
int currentPCOstate = 0;

void setup() {

  pinMode(goPin, INPUT);
  pinMode(cameraInPin, INPUT);
  pinMode(blueOutPin, OUTPUT);
  pinMode(violetOutPin, OUTPUT);
  Serial.begin(250000);
  flipflopState = 0;

  analogWriteResolution(12);

  pinMode(rampLightPin,OUTPUT);
  analogWrite(rampLightPin,0);

  pinMode(cameraOutPin,OUTPUT);
  analogWrite(cameraOutPin,0);

  pinMode(SValvePin, OUTPUT);     // solenoid valve

}

void loop() {

  // if (digitalRead(goPin)==HIGH) {
    digitalWrite(cameraOutPin, waveformsTable_sq_wave[i]);  // write the selected waveform on DAC
    i++;
    if (i==512)
      i=0;

    analogWrite(rampLightPin, waveformsTable_trp_wave[j]);  // write the selected waveform on DAC
    j++;
    if (j==512)
      j=0;

    delayMicroseconds(27.9); // to slow it down so it's at 70Hz


  // } else {
  //   // If GO pin is low, write all pins to low
  //   digitalWrite(blueOutPin, LOW);
  //   digitalWrite(violetOutPin, LOW);
  //   digitalWrite(cameraOutPin, LOW);
  //   analogWrite(rampLightPin,0);
  //   flipflopState = 0;
  // }

  // Flip lights between blue and violet whenever cameraInPin goes low
  currentPCOstate = digitalRead(cameraInPin);

  if ((currentPCOstate==LOW) & (lastPCOstate==HIGH)) { 
    flipflopState = (flipflopState+1) % 2; 
    if (flipflopState==0) {
      digitalWrite(blueOutPin, HIGH);
      digitalWrite(violetOutPin, LOW);
    } else {
      digitalWrite(blueOutPin, LOW);
      digitalWrite(violetOutPin, HIGH);
    }
  }

  lastPCOstate = currentPCOstate;

  // valve stuff
  GetBonsaiInput();
  ActivatePV();

}

/////////////////////////////////////////////////////////////////////////////
// Read inputs from Bonsai. It is an integer specifing the amount of time in ms the pintch valve stays open
void GetBonsaiInput() { // part of code taken from http://forum.arduino.cc/index.php?topic=396450.0
  static byte ndx = 0;
  char endMarker = '\r';
  char rc;

  if (Serial.available() > 0) {
    rc = Serial.read();

    if (rc != endMarker) {
      receivedChars[ndx] = rc;
      ndx++;
      if (ndx >= numChars) {
        ndx = numChars - 1;
      }
    }
    else {
      receivedChars[ndx] = '\0'; // terminate the string
      ndx = 0;
      newData = true;
    }
  }
}

/////////////////////////////////////////////////////////////////////////////
// Timer for the output signal to the pintch valve to stay high
void ActivatePV() {
  if (newData == true) {
    TimeON = 0;             // zero previous time
    TimeON = atoi(receivedChars);   // convert array of chars to integers
    if (TempVar == 0) {
      StartTime = millis();
      TempVar = 1;
    }
    newData = false;
  }
  if (TempVar == 1) {
    // start checking the time and keep the valve open as long as you wish irrespective of what happens to Serial.read()
    if ((millis() - StartTime) <= (uint32_t)TimeON) {
      digitalWrite(SValvePin, HIGH); // open valve
      TimerFinished = false;
      TempVar = 1;
    }
    else {
      digitalWrite(SValvePin, LOW); // close valve
      TimerFinished = true;
      TempVar = 0;
    }
  }
}