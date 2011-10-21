//
// ServoEasingTest1.pde -- simple example showing use of ServoEaser
//
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


unsigned long lastMillis;

//
void setup()
{
  Serial.begin(19200);

  servo1.attach( servoPin );

  servoEaser.begin( servo1, servoFrameMillis, 0 );

  Serial.println("ServoEaserTest1 ready");

  // can do manual easing instead of a moves list
  //                angle, duration 
  servoEaser.easeTo( 180, 5000);
}

//
void loop()
{
  servoEaser.update();

  if( (millis() - lastMillis) > 5000 ) {
    lastMillis = millis();
    servoEaser.easeTo( random(180), random(400,3000) );
  }
}


