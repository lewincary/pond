/* grid of shapes! */
 
int h = 40;
int count =0;
 
void setup() {
  size(800,800);
  background(0);
  noStroke();
  smooth(); 
}
 
void draw() {
 int colourCount = 1;
  if (count%10==0) { // only do this every few times draw runs
   for (int y=0; y <=height; y+=h) {
       for (int x =0; x<= width; x+=h) {
        //three random values to get the three parts of RGB
         //fill(random(0,255), random(0,255), random(0,255));
         fill(random(40,200), random(230,250), random(230,260));
         //fill(49,240,245);
         stroke(255);
         
         //model pulse
         //2d array of RGB values in chuck     
       rect(x,y,h,h);           
      }
    }
 }
   count++;
}