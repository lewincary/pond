/*

-big change to grid
-z axis control zoom
-how you present the performance 

*/

// z axis deadzone
0 => float DEADZONE;
//Initialise Button
0 => int BUTTON;
1000 => float BASERATE;
1000 => float PLAYRATE;
1000 => float LOWPASS;
1000 => float YCOLOUR;
1 => int GMODE;

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



//======================KEYBOARD SETUP======================//
// keyboard
Hid kb;
// hid message
HidMsg msg2;
if( !kb.openKeyboard( 0 ) ) me.exit();

// send object
OscSend xmit;

//Keyboard variables
1 => int PLAYMODE;


//key numbers
8 => int KEY_E;
21 => int KEY_R;
20 => int KEY_Q;
26 => int KEY_W;
18 => int KEY_O;
19 => int KEY_P;

4 => int KEY_A;
22 => int KEY_S;
7 => int KEY_D;
9 => int KEY_F;
10 => int KEY_G;
11 => int KEY_H;
13 => int KEY_J;
14 => int KEY_K;


82 => int UP;
81 => int DOWN;
30 => int NUM1;
31 => int NUM2;
32 => int NUM3;
33 => int NUM4;
34 => int NUM5;
35 => int NUM6;
79 => int RIGHT;
80 => int LEFT;


fun void keyBoard() 
{
    <<< "Keyboard ready">>>;
    while( true )
    {
        while( kb.recv( msg2 ) )
        {
            if( msg2.which > 256 ) continue;
            
            if( msg2.isButtonDown() )
            {
                <<< msg2.which >>>;
                if( msg2.which == UP)
                {
                    //
                }
                if( msg2.which == DOWN)
                {
                    //
                }
                
                if( msg2.which == KEY_O)
                {
                    //
                }
                if( msg2.which == KEY_P)
                {
                    //
                }
                if( msg2.which == NUM1)
                {
                    1 => PLAYMODE;
                    <<< "PLAYMODE: " + PLAYMODE >>>;
                    xmit.startMsg( "/foo/playmode", "i" );
                    PLAYMODE => xmit.addInt; 
                } 
                if( msg2.which == NUM2)
                {
                    2 => PLAYMODE;
                    <<< "PLAYMODE: " + PLAYMODE >>>;
                    xmit.startMsg( "/foo/playmode", "i" );
                    PLAYMODE => xmit.addInt;
                }
                if( msg2.which == NUM3)
                {
                    3 => PLAYMODE;
                    <<< "PLAYMODE: " + PLAYMODE >>>;
                    xmit.startMsg( "/foo/playmode", "i" );
                    PLAYMODE => xmit.addInt;
                }
                if( msg2.which == NUM4)
                {
                    4 => PLAYMODE;
                    <<< "PLAYMODE: " + PLAYMODE >>>;
                    xmit.startMsg( "/foo/playmode", "i" );
                    PLAYMODE => xmit.addInt;
                }
                if( msg2.which == NUM5)
                {
                    5 => PLAYMODE;
                    <<< "PLAYMODE: " + PLAYMODE >>>;
                }
                if( msg2.which == NUM6)
                {
                    6 => PLAYMODE;
                    <<< "PLAYMODE: " + PLAYMODE >>>;
                }                    
            }
            
        }
        10::ms => now;
    }
}   

//======================KEYBOARD HAS BEEN SETUP======================//





// spork control
spork ~ keyBoard();
spork ~ gametrak();
spork ~ leftControl();



//spork ~ selectGridLocation();





//print();

//Patch
TriOsc tri => ADSR env => HPF hp => NRev revvy => dac;
SawOsc saw => env => hp => revvy => dac;

TriOsc s => ADSR env1 => HPF hp2 =>  LPF lpf => NRev revvy2 => dac;

Moog sitty => revvy => dac;



/*
1000 => choir.modFreq;
0.3 => choir.modDepth;
.3 => choir.mix;
*/


80 => hp.freq;
80 => hp2.freq;
0.8 => hp2.gain;
//0.01 => hp.gain;

0.001 => tri.gain;
0.001 => saw.gain;

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
[ 50, 53, 57, 58, 62, 65, 69, 70 ] @=> int dminor[];

10 => int gridDimension;
0 => int currentX;
0 => int currentY;

0.0 => float currentXnew;
0.0 => float currentYnew;
0.0 => float currentXold;
0.0 => float currentYold;
0.0 => float zoomVal;

fun int changeInState() {
    if  (currentXold != currentXnew | currentYold != currentYnew) {
        return 1;
    } else  {
        return 0;
    }
} 

fun void playNote(float x, float y) {
    //play a note
        //<<< "CHANGE" >>>;
        Math.random2(0, 4) => int randInt;
        pentaScale[randInt] -48 + 6*y => Std.mtof => float freq;
        freq => tri.freq => saw.freq;
        env.keyOn();
        if (x == 0) {
            0.5 => x;
        }
        (x*100)::ms => now;
        //100::ms => now;
        env.keyOff();
}

fun void playSitarNote(float playSpeed, int midiNumber) {   
    midiNumber => Std.mtof => float freq;
    freq => sitty.freq;
    1 => sitty.noteOn;
    playSpeed::ms => now;
    0 => sitty.noteOff;
}



fun void playPadNote(float playSpeed, int midiNumber) {

    
    /*
    Math.random2(0, 4) => int randIndex;
    Math.random2(0,2) => int randOffset;
    pentaScale[randIndex] + 12*randOffset;
    */
    midiNumber => Std.mtof => float freq;
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



// aim the transmitter
xmit.setHost( hostname, port );

fun void leftControl() {
    while (true) {
        //-------------LEFT SIDE----------------------//
        Math.floor(gt.axis[0] * 2 * 10) => currentXnew;
        Math.floor(gt.axis[1] * 2 * 10) => currentYnew;
        //ZOOM
        Math.floor(gt.axis[2] * 8 * 10) => zoomVal;
        if (zoomVal > 19) {
            19.0 => zoomVal;
        }
        //<<< "zoom val: " + zoomVal >>>;
        //ZOOM OVER
        
        gt.axis[0] => revvy.mix;
        
        
        if (changeInState()) {
            //spork ~ playNote();
            //spork ~ playSitarNote(100, pentaScale[Math.random2(0, 4)]);
            spork ~ playNote(currentXnew, currentYnew);
        }
        
        //<<< "X: " + currentXnew + " Y: " + currentYnew >>>;
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
         xmit.startMsg( "/foo/zoom", "f" );
         zoomVal+1 => xmit.addFloat;
         
         50::ms => now;
     }
}


0 => int arpMarker;
//1 => int playMode;

// infinite time loop
while( true )
{
    
    
    //-------------RIGHT SIDE----------------------//
    //Playrate
    gt.axis[5] * 4000 => float buffer;
    BASERATE - buffer => float playSpeed;
    if (playSpeed < 0) {
        20 => playSpeed;
    }
    buffer => PLAYRATE;
    //<<< "Buffer: " + buffer + " playSpeed: " + playSpeed >>>;
    //lpf control
    Math.pow((gt.axis[3] * 100), 2) => LOWPASS => lpf.freq;
     //<<< "Lowpass: " + LOWPASS  >>>;
    
    //spork ~ playPadNote(playSpeed);
    Math.pow((gt.axis[4] * 100), 2) => YCOLOUR;
    if (PLAYMODE == 1) {     
        Math.round(gt.axis[4]*10) => float playOffset; 
        playOffset $ int => int a;
        playPadNote(playSpeed, dminor[arpMarker] + a);
        arpMarker++;
         
        if (arpMarker > 7) {
            0 => arpMarker;
        }
    }
    if (PLAYMODE == 2) {
        Math.random2(0, 4) => int randIndex;
        Math.random2(0,2) => int randOffset;
        pentaScale[randIndex] + 12*randOffset => int mNumber;
        playPadNote(playSpeed, mNumber);
    }
    if (PLAYMODE == 3) {     
        Math.round(gt.axis[4]*10) => float playOffset; 
        playOffset $ int => int a;
        playPadNote(playSpeed, dminor[arpMarker] + a);
        arpMarker--;
        
        if (arpMarker < 0) {
            7 => arpMarker;
        }
    }

    
    //-----------------------------OSC CONTROL----------------------//
    // start the message...
    // the type string 'i f' expects a int, float
    xmit.startMsg( "/foo/playrate", "f" );
    PLAYRATE => xmit.addFloat; //30-1000
    xmit.startMsg( "/foo/lowpass", "f" );
    LOWPASS => xmit.addFloat;
    xmit.startMsg( "/foo/ycolour", "f" );
    YCOLOUR => xmit.addFloat;
    // a message is kicked as soon as it is complete 
    // - type string is satisfied and bundles are closed
    // advance time
    50::ms => now;
    //0.2::second => now;
}
