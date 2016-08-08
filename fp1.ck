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

//Grid and Array
10 => int gridDimension;
0 => int currentX;
0 => int currentY;

0.0 => float currentXnew;
0.0 => float currentYnew;

while (true) {
    Math.floor(gt.axis[0] * 10) => currentXnew;
    Math.floor(gt.axis[1] * 10) => currentYnew;
    <<< "X: " + currentXnew + " Y: " + currentYnew >>>;
    1::second => now;
    
    
}

int grid[gridDimension][gridDimension];


fun void selectGrid1() {
    while (true) {
        math.round(gt.axis[0] * 10) => float currentX;
    }
    
}


fun void selectGridLocation(){
    while (true) {
        updateX();
        updateY();
        <<< "X: " + currentX + " Y: " + currentY >>>;
        20::ms => now;
        
    }
}

fun void updateY() {
    if (gt.axis[1] > 0 && gt.axis[1] < 0.1) {
        1 => grid[currentX][0];
        0 => currentY;
    } else {
        0 => grid[currentX][0];
    }
    if (gt.axis[1] > 0.1 && gt.axis[1] < 0.2) {
        1 => grid[currentX][1];
        1 => currentY;
    } else {
        0 => grid[currentX][1];
    }
    if (gt.axis[1] > 0.2 && gt.axis[1] < 0.3) {
        1 => grid[currentX][2];
        2 => currentY;
    } else {
        0 => grid[currentX][2];
    } 
    if (gt.axis[1] > 0.3 && gt.axis[1] < 0.4) {
        1 => grid[currentX][3];
        3 => currentY;
    } else {
        0 => grid[currentX][3];
    }
    if (gt.axis[1] > 0.4 && gt.axis[1] < 0.5) {
        1 => grid[currentX][4];
        4 => currentY;
    } else {
        0 => grid[currentX][4];
    }
    if (gt.axis[1] > 0.5 && gt.axis[1] < 0.6) {
        1 => grid[currentX][5];
        5 => currentY;
    } else {
        0 => grid[currentX][5];
    }
    if (gt.axis[1] > 0.6 && gt.axis[1] < 0.7) {
        1 => grid[currentX][6];
        6 => currentY;
    } else {
        0 => grid[currentX][6];
    }
    if (gt.axis[1] > 0.7 && gt.axis[1] < 0.8) {
        1 => grid[currentX][7];
        7 => currentY;
    } else {
        0 => grid[currentX][7];
    }
    if (gt.axis[1] > 0.8 && gt.axis[1] < 0.9) {
        1 => grid[currentX][8];
        8 => currentY;
    } else {
        0 => grid[currentX][8];
    }
    if (gt.axis[1] > 0.9 && gt.axis[1] < 1.0) {
        1 => grid[currentX][9];
        9 => currentY;
    } else {
        0 => grid[currentX][9];
    }
}

fun void updateX() {
    if (gt.axis[0] > 0 && gt.axis[0] < 0.1) {
        1 => grid[0][currentY];
        0 => currentX;
    } else {
        0 => grid[0][currentY];
    }
    if (gt.axis[0] > 0.1 && gt.axis[0] < 0.2) {
        1 => grid[1][currentY];
        1 => currentX;
    } else {
        0 => grid[1][currentY];
    }
    if (gt.axis[0] > 0.2 && gt.axis[0] < 0.3) {
        1 => grid[2][currentY];
        2 => currentX;
    } else {
        0 => grid[2][currentY];
    } 
    if (gt.axis[0] > 0.3 && gt.axis[0] < 0.4) {
        1 => grid[3][currentY];
        3 => currentX;
    } else {
        0 => grid[3][currentY];
    }
    if (gt.axis[0] > 0.4 && gt.axis[0] < 0.5) {
        1 => grid[4][currentY];
        4 => currentX;
    } else {
        0 => grid[4][currentY];
    }
    if (gt.axis[0] > 0.5 && gt.axis[0] < 0.6) {
        1 => grid[5][currentY];
        5 => currentX;
    } else {
        0 => grid[5][currentY];
    }
    if (gt.axis[0] > 0.6 && gt.axis[0] < 0.7) {
        1 => grid[6][currentY];
        6 => currentX;
    } else {
        0 => grid[6][currentY];
    }
    if (gt.axis[0] > 0.7 && gt.axis[0] < 0.8) {
        1 => grid[7][currentY];
        7 => currentX;
    } else {
        0 => grid[7][currentY];
    }
    if (gt.axis[0] > 0.8 && gt.axis[0] < 0.9) {
        1 => grid[8][currentY];
        8 => currentX;
    } else {
        0 => grid[8][currentY];
    }
    if (gt.axis[0] > 0.9 && gt.axis[0] < 1.0) {
        1 => grid[9][currentY];
        9 => currentX;
    } else {
        0 => grid[9][currentY];
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