//zoom code
float sval = 1.0;
float nmx, nmy;
int res = 5;

float zoomVal = 20;

/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

int firstValue;
int secondValue;

int oscXlocation;
int oscYlocation;

float PLAYRATE = 20;
float LOWPASS = 1000;
float YCOLOUR = 0;

//===GRID VARIABLES===//
// 2D Array of objects
Cell[][] grid;

// Number of columns and rows in the grid
int cols = 20;
int rows = 20;
int widthHeight = 800;

//Colours
int greenR = 123;
int greenG = 220;
int greenB = 140;

float oscR = 0;
float oscG = 0;
float oscB = 0;

float initialX;
float initialY;



void setup() {
  fullScreen();
  //size(800, 800);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,13000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",13000);
  int startX = (width - 800)/2;
  int startY = (height - 800)/2;
  
  initialX = startX;
  initialY = startY;
  
  //===GRID SETUP====//
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      //initial angle: i+ (i*i) + (j*j))
      //i*i*j*j
      grid[i][j] = new Cell(startX + i*40, startY + j*40,40,40,49,240,245, i+j);
      //i+j for diagonal
      //i for vertical sideways
      //j for horizontal downwards
      grid[i][j].display();
    }
  }
  
}

//Draw variables
int start = 0;
int mode = 1;
int colourCount = 0;


void draw() {
  background(0);
  // The counter variables i and j are also the column and row numbers and 
  // are used as arguments to the constructor for each object in the grid.  
  
  /*
    1-20 potential size grid
    map z axis from 0-20
    
  */
  
  nmx += (mouseX-nmx)/20; 
  nmy += (mouseY-nmy)/20; 

  if(mousePressed) { 
    sval += 0.1; 
  } 
  else {
    sval -= 0.1; 
  }

  sval = constrain(sval, 1.0, 10.0);

  //translate(width/2 + nmx * sval-100, height/2 + nmy*sval - 100, -50);
  scale(sval);
  
  
  //=======================//
  //mode 1: static board
  if (mode == 1) {
    if (start == 0) {
     for (int i=0; i < cols; i++) {
     for (int j=0; j <rows; j++) {
       //overwriteAngle
       grid[i][j].overwriteAngle(i*i*j*j);
     }
   }
   start++;
   }
    //------angle reset---------//
    for (int i = 0; i < zoomVal; i++) {
    for (int j = 0; j < zoomVal; j++) {
      grid[i][j].oscillate();
      grid[i][j].display2(zoomVal);
    }
   }
  }
  //=======================//
  //=======================//
  if (mode == 2) {
   if (start == 0) {
   for (int i=0; i < cols; i++) {
     for (int j=0; j <rows; j++) {
       //overwriteAngle
       grid[i][j].overwriteAngle(i*j);
     }
   }
   start++;
   }
   for (int q=0; q < zoomVal; q++) {
     for (int w=0; w <zoomVal; w++) {
      grid[q][w].oscillate();
      grid[q][w].display2(zoomVal);
     }
   }
   
  }
  //=======================//
  //=======================//
  if (mode == 3) {
   if (start == 0) {
   for (int i=0; i < cols; i++) {
     for (int j=0; j <rows; j++) {
       //overwriteAngle
       grid[i][j].overwriteAngle(i+j);
     }
   }
   start++;
   }
   for (int q=0; q < zoomVal; q++) {
     for (int w=0; w <zoomVal; w++) {
      grid[q][w].oscillate();
      grid[q][w].display2(zoomVal);
     }
   }
   
  }
  //=======================//
  //=======================//
  if (mode == 4) {
   if (start == 0) {
   for (int i=0; i < cols; i++) {
     for (int j=0; j <rows; j++) {
       //overwriteAngle
       grid[i][j].overwriteAngle(i+ (i*i) + (j*j));
     }
   }
   start++;
   }
   for (int q=0; q < zoomVal; q++) {
     for (int w=0; w <zoomVal; w++) {
      grid[q][w].oscillate();
      grid[q][w].display2(zoomVal);
     }
   }
   
  }
  //=======================//
  
  
  int currentX = 5;
  int currentY = 5;
  int newX = 8;
  int newY = 8;
  //grid[currentX][currentY].changeColour(255, 255, 255);
  grid[oscXlocation][oscYlocation].highlight();
  //Location change on gametrak
  
  if (mousePressed) {
      //will be if (location moved)
      //change old square back to normal blue colour, change new square to green colour
      start = 0;
      mode++;
      if (mode > 4) {
        mode = 1;
      }
      /*
      grid[currentX][currentY].display();
      grid[currentX][currentY].pulse();
      grid[newX][newY].changeColour(255, 255, 255);
      currentX = newX;
      currentY = newY;
      */
  }
  
 
 
 //======end of draw ====// 
}


void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  //OscMessage myMessage = new OscMessage("/foo/notes i f");
  
  //myMessage.add(0); /* add an int to the osc message */
  //myMessage.add(0.0); /* add a float to the osc message */
  /* send the message */
  //oscP5.send(myMessage, myRemoteLocation); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());

  if(theOscMessage.checkAddrPattern("/foo/notes")==true) {
    /* check if the typetag is the right one. */
    if(theOscMessage.checkTypetag("ii")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      oscXlocation = theOscMessage.get(0).intValue();  
      oscYlocation = theOscMessage.get(1).intValue();
      if (oscXlocation > 19) {
        oscXlocation = 19;
      }
      if (oscYlocation > 19) {
        oscYlocation = 19;
      }
      //println(" values: "+firstValue+", "+secondValue);
      return;
    }  
  }
  if (theOscMessage.checkAddrPattern("/foo/playrate")==true) {
     if (theOscMessage.checkTypetag("f")) {
       PLAYRATE = theOscMessage.get(0).floatValue();
       //println(" playRate: "+PLAYRATE);
      return;
     }
  }
  if (theOscMessage.checkAddrPattern("/foo/lowpass")==true) {
     if (theOscMessage.checkTypetag("f")) {
       LOWPASS = theOscMessage.get(0).floatValue();
       //println(" lowPass: "+LOWPASS);
      return;
     }
  }
  if (theOscMessage.checkAddrPattern("/foo/ycolour")==true) {
     if (theOscMessage.checkTypetag("f")) {
       YCOLOUR = theOscMessage.get(0).floatValue();
       //println(" lowPass: "+YCOLOUR);
      return;
     }
  }
  if (theOscMessage.checkAddrPattern("/foo/zoom")==true) {
     if (theOscMessage.checkTypetag("f")) {
       zoomVal = theOscMessage.get(0).floatValue();
       //println(" zoomVal: "+zoomVal);
      return;
     }
  }
}



//=================SETUP=======/////



boolean inScreenBounds(float x, float y) {
  if (x >= 0 && x < widthHeight) {
    if (y >= 0 && y < widthHeight) {
      return true;
    }
    return false;
  } else {
    return false;
  }
}

// A Cell object
class Cell {
  // A cell object knows about its location in the grid 
  // as well as its size with the variables x,y,w,h
  float x,y;   // x,y location
  float w,h;   // width and height
  float angle; // angle for oscillating brightness
  int red;
  int green;
  int blue;
  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, int r, int g, int b, float tempAngle) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    red = r;
    green = g;
    blue = b;
    angle = tempAngle;
  } 
  
  void changeColour(float r, float g, float b) {
    stroke(255);  
    fill(r, g, b);
    rect(x,y,w,h);
  }
  
  void overwriteAngle(int newAngle) {
    angle = newAngle;  
  }
  
  void pulse() {
    float x1 = x - h; 
    float x2 = x;
    float x3 = x + h;
    float y1 = y - h;
    float y2 = y;
    float y3 = y + h;
    
    
    for (int k = 0; k < 4; k++) {
          //left
          if (k == 0 && inScreenBounds(x1,y)) {
            //change previous location to blue
            drawCell(x1+h,y,w,h,oscR,oscG,oscB);
            fill(greenR, greenG, greenB);
            rect(x1,y,w,h);
          }
          //top
          if (k == 1 && inScreenBounds(x,y1)) {
            drawCell(x,y1+h,w,h,oscR,oscG,oscB);
            fill(greenR, greenG, greenB);
            rect(x,y1,w,h);
          }
          //bottom
          if (k == 2 && inScreenBounds(x,y3)) {
            drawCell(x,y3-h,w,h,oscR,oscG,oscB);
            fill(greenR, greenG, greenB);
            rect(x,y3,w,h);  
          }
          //right
          if (k == 3 && inScreenBounds(x3,y)) {
            drawCell(x3-h,y,w,h,oscR,oscG,oscB);
            fill(greenR, greenG, greenB);
            rect(x3,y,w,h);      
          }  
    }
   
    //update coordinates
    x1 = x1 - h;
    y1 = y1 - h;
    y3 = y3 + h;
    x3 = x3 + h;
    
    /*
    //pause 2
    int waitingTime = 1000;
    int timeShot = millis();
    while (millis() - timeShot < waitingTime) {
    //wait
    }
    */
    
    //======end=======////
    
    
    
    }
  
  void oscillate() {
    angle += (PLAYRATE/1000);
    
    
  }
    
  void highlight() {
    stroke(0);
    strokeWeight(3);
    rect(x,y,w,h); 
  }
  
  void display() {
    stroke(255);
    // Color calculated using sine wave
    //fill(red, green, blue);
    float offset = (LOWPASS/300)*2;
    if (offset > 240) {
      offset = 200;
    }
    println(" offset: "+offset);
    oscR = 5 + offset*2*3;
    oscG = 214 + 40*sin(angle) - (offset/2);
    oscB = 214 + 40*sin(angle) - offset*2;
    fill(oscR, oscG ,oscB);
    rect(x,y,w,h); 
  }
  void display2(float zoomAmount) {
    stroke(255);
    // Color calculated using sine wave
    //fill(red, green, blue);
    float offset = (LOWPASS/300)*2;
    float offset2 = (YCOLOUR/300)*2;
    if (offset > 240) {
      offset = 200;
    }
    println(" offset: "+offset);
    oscR = 5 + offset*2*3 - offset2*2;
    oscG = 214 + 40*sin(angle) - (offset/2) + offset2*2;
    oscB = 214 + 40*sin(angle) - offset*2 + offset2*2;
    fill(oscR, oscG ,oscB);
    rect(x,y,800/zoomAmount,800/zoomAmount); 
  }
  
}

void drawCell(float x, float y, float w, float h, float newR, float newG, float newB) {
  stroke(255);
  fill(newR, newG, newB);
  rect(x,y,w,h); 
}

/*
  //mode 3: colour change
  if (mode == 2) {
  if (colourCount%10==0) { //only do this every few runs
   for (int q=0; q < cols; q++) {
     for (int w=0; w < rows; w++) {    
        grid[q][w].changeColour(random(40,200), random(230,250), random(230,260));
        //grid[q][w].display();
       } 
     }
   }
   colourCount++; 
   }
  //=======================//
  */