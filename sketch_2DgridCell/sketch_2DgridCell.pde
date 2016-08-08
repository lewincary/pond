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

void setup() {
  size(800, 800);
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      grid[i][j] = new Cell(i*40,j*40,40,40,49,240,245, i+ (i*i) + (j*j));
      //i+j for diagonal
      //i for vertical sideways
      //j for horizontal downwards
      grid[i][j].display();
    }
  }
}

int start = 0;
int mode = 2;
int colourCount = 0;

void draw() {
  background(0);
  // The counter variables i and j are also the column and row numbers and 
  // are used as arguments to the constructor for each object in the grid.  

  //=======================//
  //mode 1: static board
  if (mode == 1) {
    for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].display();
    }
   }
  }
  //=======================//
  //mode 2: moving board
  if (mode == 2) {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Oscillate and display each object
      grid[i][j].oscillate();
      grid[i][j].display();
    }
   }
  }
  //=======================//
  //mode 3: colour change
  if (mode == 3) {
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
  
  
  int currentX = 5;
  int currentY = 5;
  int newX = 8;
  int newY = 8;
  //grid[currentX][currentY].changeColour(255, 255, 255);
  grid[currentX][currentY].highlight();
  //Location change on gametrak
  if (mousePressed) {
      //will be if (location moved)
      //change old square back to normal blue colour, change new square to green colour
      grid[currentX][currentY].display();
      grid[currentX][currentY].pulse();
      grid[newX][newY].changeColour(255, 255, 255);
      currentX = newX;
      currentY = newY;
  }
 
 
 //======end of draw ====// 
}

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
    angle += 0.04; 
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
    oscR = 5;
    oscG = 214 + 40*sin(angle);
    oscB = 214 + 40*sin(angle);
    fill(oscR, oscG ,oscB);
    rect(x,y,w,h); 
  }
}

void drawCell(float x, float y, float w, float h, float newR, float newG, float newB) {
  stroke(255);
  fill(newR, newG, newB);
  rect(x,y,w,h); 
}