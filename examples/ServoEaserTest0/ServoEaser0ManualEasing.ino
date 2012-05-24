//
// ServoEaser0ManualEasing.ino - show how to send 
//
// 2011, TeamPneumo, Tod E. Kurt, http://todbot.com/blog/
//
//

#include <Servo.h>
#include "ServoEaser.h"

const int ledPin   = 13; 
const int servoPin = 7;

int servoFrameMillis = 10;  // minimum time between servo updates

Servo servo1; 
ServoEaser servoEaser;

//
void setup()
{
  Serial.begin(19200);
  Serial.println("ServoEaser0ManualEasing");

  // first, get the servo ready
  servo1.attach( servoPin );

  // begin with just a framerate and starting position (0 degrees)
  servoEaser.begin( servo1, servoFrameMillis, 0 );

  // do manual easing, from 0 to 180 in 3 seconds
  servoEaser.easeTo( 180, 3000);
}

//
void loop()
{
  servoEaser.update();

  if( servoEaser.hasArrived() ) { 
    Serial.println("ServoEaser arrived at 180 degrees,");
    Serial.println("going to 90 in 5 seconds");
    servoEaser.easeTo( 90, 5000 );
  }
    
}


