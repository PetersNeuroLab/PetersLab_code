#include "sq_wave.h"
#include "trp_wave.h"


volatile int i = 0;
volatile int j = 0;

const int goPin = 0; // pin for experiment

const int cameraOutPin = 29;

const int cameraInPin = 30;    // pin for "all lines exposing"
const int blueOutPin = 24;       // pin for blue's Gate1
const int purpleOutPin = 25;       // pin for purple's Gate1


int flipflopState = 0;        
int lastPCOstate = 0;
int currentPCOstate = 0;

void setup() {

  pinMode(goPin, INPUT);
  pinMode(cameraInPin, INPUT);
  pinMode(blueOutPin, OUTPUT);
  pinMode(purpleOutPin, OUTPUT);
  Serial.begin(9600);
  flipflopState = 0;

  analogWriteResolution(12);

  pinMode(A22,OUTPUT);
  analogWrite(A22,0);

  pinMode(cameraOutPin,OUTPUT);
  analogWrite(cameraOutPin,0);
}

void loop() {

  // if (digitalRead(goPin)==HIGH) {
    analogWrite(cameraOutPin, waveformsTable_sq_wave[i]);  // write the selected waveform on DAC
    i++;
    if (i==512)
      i=0;

    analogWrite(A22, waveformsTable_trp_wave[j]);  // write the selected waveform on DAC
    j++;
    if (j==512)
      j=0;

    delayMicroseconds(27.9); // to slow it down so it's at 70Hz

      currentPCOstate = digitalRead(cameraInPin);

    if ((currentPCOstate==LOW) & (lastPCOstate==HIGH)) { 
      flipflopState = (flipflopState+1) % 2; 

      if (flipflopState==0) {
        digitalWrite(blueOutPin, HIGH);
        digitalWrite(purpleOutPin, LOW);
      } else {
        digitalWrite(blueOutPin, LOW);
        digitalWrite(purpleOutPin, HIGH);
      }
    }

    lastPCOstate = currentPCOstate;
  // }

}