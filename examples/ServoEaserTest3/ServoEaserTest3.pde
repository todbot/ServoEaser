//
// ServoEasingTest1.pde -- showing use of ServoEaser callbak functions
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


// configurable list of servo moves
int myServoMovesCount = 2;
ServoMove myServoMoves[] = {
// angle, duration
  { 45, 2000},
  {135, 2000},
};

// from Easing::linearTween()
float linearTween (float t, float b, float c, float d) {
	return c*t/d + b;
}
// from Easing::easeInOutQuad()
float easeInOutQuad (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return c/2*t*t + b;
	return -c/2 * ((--t)*(t-2) - 1) + b;
}
// from Easing::easeInOutCubic()
float easeInOutCubic (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return c/2*t*t*t + b;
	return c/2*((t-=2)*t*t + 2) + b;
}
// from Easing::easeInOutQuart()
float easeInOutQuart (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
	return -c/2 * ((t-=2)*t*t*t - 2) + b;
}
// from Easing::easeInOutQuint()
float easeInOutQuint (float t, float b, float c, float d) {
	if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
	return c/2*((t-=2)*t*t*t*t + 2) + b;
}
// bounce easing out
float easeOutBounce (float t, float b, float c, float d) {
	if ((t/=d) < (1/2.75)) {
		return c*(7.5625*t*t) + b;
	} else if (t < (2/2.75)) {
		return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
	} else if (t < (2.5/2.75)) {
		return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
	} else {
		return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
	}
}


EasingFunc easingFuncs[] = { linearTween, 
                             easeInOutCubic, 
                             easeInOutQuad, 
                             easeInOutQuart, 
                             easeInOutQuint, 
                             easeOutBounce, 
};
int easingFuncCount = 6;

int i = 0;

// called by servoeaser when servo hits destination
void myArrivedFunc( int currPos, int movesIndex )
{
  Serial.print("myArrivedFunc: currPos=");
  Serial.print(currPos);
  Serial.print(", movesIndex=");
  Serial.print(movesIndex);
  if( movesIndex == 0 ) {
    Serial.print("  switching to func #");
    Serial.print(i);
    servoEaser.setEasingFunc( easingFuncs[i] );
    i++;
    if( i == easingFuncCount ) i = 0;
  } 
  Serial.println();
}

//
void setup()
{
  Serial.begin(19200);

  servo1.attach( servoPin );

  servoEaser.begin( servo1, servoFrameMillis, myServoMoves, myServoMovesCount);
  servoEaser.setArrivedFunc( myArrivedFunc );

  Serial.println("ServoEaserTest3 ready");

}

//
void loop()
{

  servoEaser.update();

}


