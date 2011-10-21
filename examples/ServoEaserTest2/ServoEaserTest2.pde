//
// ServoEaserTest2.pde -- more complex example of using ServoEaser 
//                        this time with move lists
//
// 2011, TeamPneumo, Tod E. Kurt, http://todbot.com/blog/
//
//

#include <Servo.h>
#include "ServoEaser.h"
//#include <Easing.h>

const int ledPin   = 13; 
const int servoPin = 7;

Servo servo1; 

int servoFrameMillis = 10;  // minimum time between servo updates

ServoEaser servoEaser;

// configurable list of servo moves
int myServoMovesCount = 8;
ServoMove myServoMoves[] = {
// angle, duration
  {  0, 2000},
  {180, 2000},
  {  0, 1500},
  {180, 1500},
  { 90,  800},
  {180, 2000},
  { 45, 3000},
  {135, 3000},
};


// from Easing::linearTween()
float linearTween (float t, float b, float c, float d) {
	return c*t/d + b;
}
// from Easing::easeInOutQuart()
float easeInOutQuart (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
	return -c/2 * ((t-=2)*t*t*t - 2) + b;
}


//
void setup()
{
  Serial.begin(19200);

  servo1.attach( servoPin );

  // can begin with a list of servo moves
  //servoEaser.begin( servo1, servoFrameMillis,myServoMoves,myServoMovesCount);
  // or begin with just a framerate and starting position
  servoEaser.begin( servo1, servoFrameMillis, 0 );
  // and then set moves list later (or not at all)
  servoEaser.setMovesList( myServoMoves, myServoMovesCount );

  // ServoEaser defaults to easeInOutCubic() but you can change it
  //servoEaser.setEasingFunc( linearTween );
  //servoEaser.setEasingFunc( easeInOutQuart );
  // can even use Easing library if you want
  //servoEaser.setEasingFunc( Easing::easeInOutExpo );

  Serial.println("ServoEasingTest2 ready");

  // can do manual easing instead of a moves list
  //servoEaser.easeTo( 180, 5000);
}

//
void loop()
{
  servoEaser.update();

  /*
  // can do manual easing too
  if( millis() > 6000 && millis() < 6005 ) { 
    servoEaser.easeTo( 0, 3000 );
  }
  if( millis() > 10000 && millis() < 10005 ) {
    servoEaser.easeTo( 45, 5000 );
  }
  */
    
}


