//
// ServoEaserTest0.pde -- more complex example of using ServoEaser 
//                        this time with move lists
//
// 2011, TeamPneumo, Tod E. Kurt, http://todbot.com/blog/
//
//

#include <Servo.h>
#include "ServoEaser.h"

const int ledPin   = 13; 
const int servoPin = 7;

Servo servo1; 

int servoFrameMillis = 10;  // minimum time between servo updates

ServoEaser servoEaser;


//
void setup()
{
  Serial.begin(19200);

  servo1.attach( servoPin );

  // begin with just a framerate and starting position (0 degrees)
  servoEaser.begin( servo1, servoFrameMillis, 0 );

  Serial.println("ServoEasingTest0 ready");

  // can do manual easing, from 0 to 180 in 3 seconds
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


