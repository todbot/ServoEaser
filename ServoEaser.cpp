//
// ServoEaser.cpp -- Arduino library for Servo easing
//
// Uses concepts from:
// -- http://portfolio.tobiastoft.dk/331886/Easing-library-for-Arduino
// -- http://jesusgollonet.com/processing/pennerEasing/
// -- http://robertpenner.com/easing/
// -- http://robertpenner.com/easing/easing_demo.html
//
// 2011, TeamPneumo, Tod E. Kurt, http://todbot.com/blog/
// 
//

#include "ServoEaser.h"
#include <math.h>

// default easing function
// this is from Easing::easeInOutCubic()
// t: current time, b: beginning value, c: change in value, d: duration
// t and d can be in frames or seconds/milliseconds
float ServoEaser_easeInOutCubic(float t, float b, float c, float d)
{
    if ((t/=d/2) < 1) return c/2*t*t*t + b;
	return c/2*((t-=2)*t*t + 2) + b;
}

// set up an easer with a servo and a moves list
void ServoEaser::begin(Servo s, int frameTime, 
                       ServoMove* mlist, int mcount)
{
    servo = s;
    frameMillis = frameTime;
    moves = mlist;
    movesCount = mcount;

    easingFunc = ServoEaser_easeInOutCubic;
    arrivedFunc = NULL;

    reset();
}

// set up an easer with just a servo and a starting position
void ServoEaser::begin(Servo s, int frameTime, int pos )
{
    servo = s;
    frameMillis = frameTime;
    startPos = pos;

    easingFunc = ServoEaser_easeInOutCubic;
    arrivedFunc = NULL;

    reset();
}

// reset easer to initial conditions, does not nuke easingFunc or arrivedFunc
void ServoEaser::reset()
{
    movesIndex = 0;

    if( movesCount > 0 ) {
        startPos  = moves[ movesIndex ].pos;  // get first position
        durMillis = moves[ movesIndex ].dur;
    }
    currPos  = startPos;  // get everyone in sync
    changePos = 0; 

    tickCount = durMillis / frameMillis;
    tick = 0;
    
    running = true;
}

//
void ServoEaser::setEasingFunc( EasingFunc func )
{
    easingFunc = func;
}

void ServoEaser::setArrivedFunc( ArrivedFunc func ) 
{
    arrivedFunc = func;
}

//
void ServoEaser::setMovesList( ServoMove* mlist, int mcount )
{
    moves = mlist;
    movesCount = mcount;
    reset();
}

// manual, non-moves list, control of easer position
void ServoEaser::easeTo( int pos, int dur )
{
    movesCount = 0;  // no longer doing moves list
    startPos = currPos;
    changePos = pos - startPos;
    durMillis = dur;
    tickCount = durMillis / frameMillis;
    tick = 0;
    arrived = false;
}

// used internally to select next servo position
void ServoEaser::getNextPos()
{
    arrived = true;
    if( arrivedFunc != NULL ) { arrivedFunc( currPos, movesIndex ); }

    if( movesCount==0 ) { // not in a moves list
        return;
    }

    movesIndex++;
    if( movesIndex == movesCount ) {
        movesIndex = 0;
    }
    startPos  = currPos; // current position becomes new start position

    changePos = moves[ movesIndex ].pos - startPos ;
    durMillis = moves[ movesIndex ].dur;

    tickCount = durMillis / frameMillis;
    tick = 0;
    arrived = false;
}

// call this regularly in loop()
void ServoEaser::update()
{
    if( ((millis() - lastMillis) < frameMillis) || !running ) {  // time yet?
        return;
    }
    lastMillis = millis();

    currPos = easingFunc( tick, startPos, changePos, tickCount );
    
    if( !arrived ) tick++;
    if( tick == tickCount ) { // time for new position
        getNextPos(); 
    }
    servo.write( currPos );
}

//
void ServoEaser::start()
{
    running = true;
}
//
void ServoEaser::stop()
{
    running = false;
}
//
boolean ServoEaser::isRunning()
{ 
    return running;
}
//
boolean ServoEaser::hasArrived()
{ 
    return arrived;
}

 

