/* grid of shapes! */
 
int h = 80;
int count =0;

//current location
int currentX;
int currentY;
 
int rows = 10;
int cols = 10;
int[][] grid = new int[rows][cols];


 
void setup() {
  size(800,800);
  background(0);
  noStroke();
  smooth(); 
  /*
  //Array setup
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; i++) {
      grid[i][j] = int(random(0,255));
    }
  }
  */
  //Grid setup
  for (int y=0; y <=height; y+=h) {
       for (int x =0; x<= width; x+=h) {
        currentX += x;
        currentY += y;
        fill(49,240,245);
        stroke(255);  
        rect(x,y,h,h);           
       }
   }
}


 
void draw() {
     int count = 0;
     
     fill(200,100,245);
     rect(80,80,h,h);
}