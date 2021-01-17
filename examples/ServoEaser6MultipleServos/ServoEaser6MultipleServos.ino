//
// ServoEaser6MultipleServos.ino -- Show how to ease multiple servos 
//

#include <Servo.h>
#include "ServoEaser.h"

const int servo1Pin = 7;
const int servo2Pin = 6;

int servoFrameMillis = 10;  // time between servo updates

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

//
void setup()
{
  Serial.begin(19200);
  Serial.println("ServoEaser6MultipleServos");

  servo1.attach( servo1Pin );
  servo2.attach( servo2Pin );

  servo1Easer.begin( servo1, servoFrameMillis );
  servo2Easer.begin( servo2, servoFrameMillis );
  servo2Easer.setFlipped( true );

  servo1Easer.play( myServoMoves, myServoMovesCount );
  servo2Easer.play( myServoMoves, myServoMovesCount );
}

//
void loop()
{
  servo1Easer.update();
  servo2Easer.update();
}
