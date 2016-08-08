
int largo = 10;
int r = 0;
int g = 0 ;
int b = 0;
void setup() {
  size(300,300);


}

void draw() 
{
 
  frameRate(12);
for (int x = 0; x < width; x+=10) 
{
  for (int y = 0; y < height; y+=20)
  {
    stroke(255);
    fill(r,g,b);
    rect(x,y,largo-1,largo-1);
}
    r +=mouseX+ random(25);
  g += mouseX+random(25);
    b += mouseX+random(25);
    
  
  if ( r > 255 )
{
    r = 0;
}
  if ( g > 255 )
{
    g = 0;
}

  if ( b > 255 )
{
    b = 0;
}
} 

}
 