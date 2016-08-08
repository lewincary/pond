// z axis deadzone
0 => float DEADZONE;
//Initialise Button
0 => int BUTTON;

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

//Patch
TriOsc tri => ADSR env => NRev revvy => dac;
env.set( 10::ms, 10::ms, .5, 200::ms );
env.keyOff;



0.2 => revvy.mix;



//Grid and Array
[ 61, 63, 66, 68, 70 ] @=> int pentaScale[];

10 => int gridDimension;
0 => int currentX;
0 => int currentY;

0.0 => float currentXnew;
0.0 => float currentYnew;
0.0 => float currentXold;
0.0 => float currentYold;

while (true) {
    Math.floor(gt.axis[0] * 10) => currentXnew;
    Math.floor(gt.axis[1] * 10) => currentYnew;
    
    
    if (changeInState()) {
        spork ~ playNote();
        
    }
    
    <<< "X: " + currentXnew + " Y: " + currentYnew >>>;
    10::ms => now;
    currentXnew => currentXold;
    currentYnew => currentYold;
    
    
}

fun void playNote() {
    //play a note
    <<< "CHANGE" >>>;
    Math.random2(0, 4) => int randInt;
    pentaScale[randInt] => Std.mtof => float freq;
    freq => tri.freq;
    env.keyOn();
    100::ms => now;
    env.keyOff();
}

fun int changeInState() {
    if  (currentXold != currentXnew | currentYold != currentYnew) {
        return 1;
    } else  {
        return 0;
    }
} 

// print
fun void print()
{
    // time loop
    while( true )
    {
        // values
        <<< "axes:", gt.axis[0],gt.axis[1],gt.axis[2],
        gt.axis[3],gt.axis[4],gt.axis[5] >>>;
        // advance time
        100::ms => now;
    }
}



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