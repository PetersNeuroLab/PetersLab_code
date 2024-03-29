
const int camerainPin = 12;    // pin for "all lines exposing"
const int blueOutPin = 7;       // pin for blue's Gate1
const int purpleOutPin = 6;       // pin for purple's Gate1
const int cameraOutPin = 11;

// const int acqLiveInPin = 5;       // pin for acqLive from Timeline
// const int extraGndPin = 13;       // pin for acqLive from Timeline

// const int poissonPin = 7;
// const int minPoissonDur = 10; //ms
// const int maxPoissonDur = 200; //ms

int flipflopState = 0;         // current state of the alternation
int lastPCOstate = 0;
int currentPCOstate = 0;
// int lastAcqLiveState = 0;
// int currentAcqLiveState = 0;

// unsigned long lastFlipTime = 0;
unsigned long timeNow = 0;
// unsigned long poissonStateDur = 0;
// int currentPoissonState = 0;

void setup() {
  // put your setup code here, to run once:
  pinMode(camerainPin, INPUT);
  pinMode(blueOutPin, OUTPUT);
  pinMode(purpleOutPin, OUTPUT);
  pinMode(cameraOutPin,OUTPUT);
  // pinMode(acqLiveInPin, INPUT);
  // pinMode(extraGndPin, OUTPUT);
  Serial.begin(9600);
  // digitalWrite(extraGndPin, LOW);

  TCCR2B = TCCR2B & 0b11111000 | 0x07; // for PWM frequency of 30.51 Hz

  // pinMode(poissonPin, OUTPUT);
  // digitalWrite(poissonPin, LOW);
  // currentPoissonState = LOW;
  // poissonStateDur = random(minPoissonDur, maxPoissonDur);
  // lastFlipTime = millis();
  flipflopState = 0;
}

void loop() {
  // put your main code here, to run repeatedly:

  // currentAcqLiveState = digitalRead(acqLiveInPin);
  // timeNow = millis();

  // if (currentAcqLiveState==HIGH & lastAcqLiveState==LOW) { 
  //   flipflopState = 0; // guarantee that color is blue on first frame when acquisition starts. 
  //   digitalWrite(blueOutPin, HIGH);
  //   digitalWrite(purpleOutPin, LOW);
  // }

  // lastAcqLiveState = currentAcqLiveState;

  analogWrite(cameraOutPin,127);

  currentPCOstate = digitalRead(camerainPin);

  if (currentPCOstate==HIGH & lastPCOstate==LOW) { 
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

  // //code for flipper
  // if (currentAcqLiveState==HIGH && (timeNow-lastFlipTime)>poissonStateDur) {
  //   lastFlipTime = timeNow;
  //   if (currentPoissonState==LOW){
  //     currentPoissonState=HIGH;
  //   } else {
  //     currentPoissonState=LOW;
  //   }
  //   digitalWrite(poissonPin, currentPoissonState);
  //   poissonStateDur = random(minPoissonDur, maxPoissonDur);
  // } else if (timeNow < lastFlipTime) {
  //   // this can only happen when the millis() function wraps around at the limit of the unsigned long datatype
  //   lastFlipTime = 1; // pretend we flipped at 1
  // }
  
  // delayMicroseconds(50);
}
