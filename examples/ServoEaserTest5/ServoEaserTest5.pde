//
// ServoEaserTest5.pde -- Show how to asynchronously sync up two servos 
//
//
// 2011, TeamPneumo, Tod E. Kurt, http://todbot.com/blog/
//
//

#include <Servo.h>
#include "ServoEaser.h"

const int ledPin   = 13; 
const int servo1Pin = 7;
const int servo2Pin = 6;
const int buttonPin = 2;

int servoFrameMillis = 20;  // minimum time between servo updates

Servo servo1; 
Servo servo2;

ServoEaser servo1Easer;
ServoEaser servo2Easer;


int myServoMovesCount = 8;
// configurable list of servo moves
ServoMove myServoMoves[] = {
// angle, duration
    {0,   3000},
    {45,  1000},
    {20,   500},
    {90,  1000},
    {45,  2000},
    {135, 2000},
    {75,  1000},
    {165, 1000},
};

boolean buttonPressed = false;

// on button press, bring in 2nd servo in sync with first
void buttonCheck( int currPos, int mIndex ) {
    if( buttonPressed ) {
        Serial.print("button pressed at "); Serial.println( mIndex );
        servo2Easer.play( myServoMoves, myServoMovesCount, 0, mIndex+1 );
        buttonPressed = false;
    }
}

//
void setup()
{
  Serial.begin(19200);
  Serial.println("ServoEasingTest5");

  servo1.attach( servo1Pin );
  servo2.attach( servo2Pin );

  servo1Easer.begin( servo1, servoFrameMillis, 90 );
  servo2Easer.begin( servo2, servoFrameMillis, 90 );
  servo2Easer.setFlipped( true );

  pinMode( buttonPin, INPUT);
  digitalWrite( buttonPin, HIGH); // turn on internal pullup resistor

  servo1Easer.play( myServoMoves, myServoMovesCount );
  //servo2Easer.play( myServoMoves, myServoMovesCount );

  servo1Easer.setArrivedFunc( buttonCheck );
}

//
void loop()
{
  servo1Easer.update();
  servo2Easer.update();

  if( digitalRead(buttonPin) == LOW ) {
      Serial.println("button pressed");
      buttonPressed = true;
  }
}


