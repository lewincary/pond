// z axis deadzone
0 => float DEADZONE;
//Initialise Button
0 => int BUTTON;
1000 => float BASERATE;
1000 => float PLAYRATE;
1000 => float LOWPASS;

// which joystick
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// HID objects
Hid trak;
HidMsg msg;


// open joystick 0, exit on fail
if( !trak.openJoystick( device ) ) me.exit();

<<< "joystick '" + trak.name() + "' ready", "" >>>;

// data structure for gametrak
class GameTrak
{
    // timestamps
    time lastTime;
    time currTime;
    
    // previous axis data
    float lastAxis[6];
    // current axis data
    float axis[6];
}

// gametrack
GameTrak gt;

// spork control
spork ~ gametrak();
//spork ~ selectGridLocation();





//print();

TriOsc s => ADSR env1 => LPF lpf => NRev revvy2 => dac;

[ 61, 63, 66, 68, 70 ] @=> int pentaScale[];

env1.set( 100::ms, 40::ms, .03, 100::ms );
env1.keyOff;
0.2 => revvy2.mix;
LOWPASS => lpf.freq;
0.2 => s.gain;

while (true) {
    //Playrate
    gt.axis[5] * 4000 => float buffer;
    BASERATE - buffer => float playSpeed;
    if (playSpeed < 0) {
        20 => playSpeed;
    }
    playSpeed => PLAYRATE;
    <<< "Buffer: " + buffer + " playSpeed: " + playSpeed >>>;
    //lpf control
    Math.pow((gt.axis[3] * 100), 2) => LOWPASS => lpf.freq;
    
    
    
    Math.random2(0, 4) => int randIndex;
    Math.random2(0,2) => int randOffset;
    pentaScale[randIndex] + 12*randOffset => Std.mtof => float freq;
    
    freq => s.freq;
    env1.keyOn();
    playSpeed::ms => now;
    env1.keyOff();
}


//have flow rate of graphics tied to how quickly the music/arp is moving 


/*

ie. performance starts off as static

left and right sticks control the sound

whatever is happening in sound is being mirrored by the graphics.
-ie. increase in tempo increases the swirling rate of the graphics
- keep track of these in global variables (ie. a RATE variable, that is sent over OSC that modifies the oscillate addition rate)
- have different patterns across the screen for different parts
- LOWPASS controls the colour range (so when you open the lpf up you get brighter colours) 


in background have constant pad/textures, which are reflected in the graphics patterns (like this example sine code)
pad plan:
sort of random, based on energy levels, goes from
this pad is the background flow rate of the piece, it sets the tone


//THIS IS WHAT YOU DO:

hook up playrate to upwards pull (on right)
hook up lpf filter control to x axis



*/



// gametrack handling
fun void gametrak()
{
    while( true )
    {
        // wait on HidIn as event
        trak => now;
        
        // messages received
        while( trak.recv( msg ) )
        {
            // joystick axis motion
            if( msg.isAxisMotion() )
            {            
                // check which
                if( msg.which >= 0 && msg.which < 6 )
                {
                    // check if fresh
                    if( now > gt.currTime )
                    {
                        // time stamp
                        gt.currTime => gt.lastTime;
                        // set
                        now => gt.currTime;
                    }
                    // save last
                    gt.axis[msg.which] => gt.lastAxis[msg.which];
                    // the z axes map to [0,1], others map to [-1,1]
                    if( msg.which != 2 && msg.which != 5 )
                    { (msg.axisPosition + 1)/ 2 => gt.axis[msg.which]; }
                    else
                    { 1 - ((msg.axisPosition + 1) / 2) => gt.axis[msg.which];
                    if( gt.axis[msg.which] < 0 ) 0 => gt.axis[msg.which]; }
                }
            }
            
            // joystick button down
            else if( msg.isButtonDown() )
            {
                // <<< "button", msg.which, "down" >>>;
                1 => BUTTON;
                //code for if button is down
            }
            
            // joystick button up
            else if( msg.isButtonUp() )
            {
                // <<< "button", msg.which, "up" >>>;
                0 => BUTTON;
            }
        }
    }
}
