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
spork ~ leftControl();
//spork ~ selectGridLocation();





//print();

//Patch
TriOsc tri => ADSR env => NRev revvy => dac;

TriOsc s => ADSR env1 => LPF lpf => NRev revvy2 => dac;

StifKarp sitty => revvy => dac;

0.1 => sitty.gain;

env1.set( 100::ms, 40::ms, .03, 100::ms );
env1.keyOff;
0.2 => revvy2.mix;
LOWPASS => lpf.freq;
0.2 => s.gain;

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

fun int changeInState() {
    if  (currentXold != currentXnew | currentYold != currentYnew) {
        return 1;
    } else  {
        return 0;
    }
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

fun void playSitarNote() {
    Math.random2(0, 4) => int randInt;
    pentaScale[randInt] => Std.mtof => float freq;
    freq => sitty.freq;
    1 => sitty.noteOn;
    100::ms => now;
    0 => sitty.noteOff;
}

fun void playPadNote(float playSpeed) {
    Math.random2(0, 4) => int randIndex;
    Math.random2(0,2) => int randOffset;
    pentaScale[randIndex] + 12*randOffset => Std.mtof => float freq;
    
    freq => s.freq;
    env1.keyOn();
    playSpeed::ms => now;
    env1.keyOff();
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


//-------------Sound has been setup-----------------//


// launch with r.ck

// name
"localhost" => string hostname;
13000 => int port;

// check command line
if( me.args() ) me.arg(0) => hostname;
if( me.args() > 1 ) me.arg(1) => Std.atoi => port;

// send object
OscSend xmit;

// aim the transmitter
xmit.setHost( hostname, port );

fun void leftControl() {
    while (true) {
        //-------------LEFT SIDE----------------------//
        Math.floor(gt.axis[0] * 2 * 10) => currentXnew;
        Math.floor(gt.axis[1] * 2 * 10) => currentYnew;
        
        gt.axis[0] => revvy.mix;
        
        
        if (changeInState()) {
            //spork ~ playNote();
            spork ~ playSitarNote();
        }
        
        <<< "X: " + currentXnew + " Y: " + currentYnew >>>;
        //100::ms => now;
        currentXnew => currentXold;
        currentYnew => currentYold;
        
         //-----------------------------OSC CONTROL----------------------//
         // start the message...
         // the type string 'i f' expects a int, float
         //xmit.startMsg( "/foo/notes", "i f" );
         
         
         xmit.startMsg( "/foo/notes", "i i" );
         currentXnew $ int => int oscX;
         currentYnew $ int => int oscY;
         Std.abs(oscY-19) => oscY;
         oscX => xmit.addInt;
         oscY => xmit.addInt;
         50::ms => now;
     }
}



// infinite time loop
while( true )
{
    /*
    //-------------LEFT SIDE----------------------//
    Math.floor(gt.axis[0] * 2 * 10) => currentXnew;
    Math.floor(gt.axis[1] * 2 * 10) => currentYnew;
    
    gt.axis[0] => revvy.mix;
    
    
    if (changeInState()) {
        //spork ~ playNote();
        spork ~ playSitarNote();
    }
    
    <<< "X: " + currentXnew + " Y: " + currentYnew >>>;
    //100::ms => now;
    currentXnew => currentXold;
    currentYnew => currentYold;
    */
    
    //-------------RIGHT SIDE----------------------//
    //Playrate
    gt.axis[5] * 4000 => float buffer;
    BASERATE - buffer => float playSpeed;
    if (playSpeed < 0) {
        20 => playSpeed;
    }
    buffer => PLAYRATE;
    <<< "Buffer: " + buffer + " playSpeed: " + playSpeed >>>;
    //lpf control
    Math.pow((gt.axis[3] * 100), 2) => LOWPASS => lpf.freq;
     <<< "Lowpass: " + LOWPASS  >>>;
    
    //spork ~ playPadNote(playSpeed);
    
    Math.random2(0, 4) => int randIndex;
    Math.random2(0,2) => int randOffset;
    pentaScale[randIndex] + 12*randOffset => Std.mtof => float freq;
    
    freq => s.freq;
    env1.keyOn();
    playSpeed::ms => now;
    env1.keyOff();
    
    
    //-----------------------------OSC CONTROL----------------------//
    // start the message...
    // the type string 'i f' expects a int, float
    //xmit.startMsg( "/foo/notes", "i f" );
    
    /*
    xmit.startMsg( "/foo/notes", "i i" );
    currentXnew $ int => int oscX;
    currentYnew $ int => int oscY;
    Std.abs(oscY-19) => oscY;
    oscX => xmit.addInt;
    oscY => xmit.addInt;
    */
    xmit.startMsg( "/foo/playrate", "f" );
    PLAYRATE => xmit.addFloat; //30-1000
    xmit.startMsg( "/foo/lowpass", "f" );
    LOWPASS => xmit.addFloat;
    // a message is kicked as soon as it is complete 
    // - type string is satisfied and bundles are closed
    //Math.random2( 30, 80 ) => xmit.addInt;
    //Math.random2f( .1, .5 ) => xmit.addFloat;

    // advance time
    50::ms => now;
    //0.2::second => now;
}
