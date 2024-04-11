/**
 ****************************************************************************
 * @file    Haptic Mouse Project for 16-880 
 * @author  lchomas@andrew.cmu.edu
 * @version 1.0
 * @date    April-2024
 * @brief   Sends data to haptic mouse based on collision of cursor with line
 ****************************************************************************
 */


int windowHeight = 800; //these have to match the window width and length declared in size
int windowWidth = 1200;

int cursorSize = 20; //size of the Haplink cursor in pixels

int h = 500;
float x1, y1, x2, y2;
float m, b;
float delta = 2;
float dist;
float theta_r;

boolean collision = false;

void setup()
{
  size(windowWidth, windowHeight); //make our canvas 800 x 800 pixels big
  setupCom();
  
}


void draw() 
{
  background(255,255,255);
  
if (myPort != null)
{
     
  //draw the outlines in black
  stroke(0);
  //draw cursor as a ball
  fill(127,255,212); 
  ellipse(mouseX, mouseY, cursorSize, cursorSize);
  fill(0);
  ellipse(mouseX, mouseY, 2, 2);

  theta_r = theta*PI/180;
  x1 = 500;
  y1 = 100;
  x2 = x1 + round(h*cos(theta_r));
  y2 = y1 + round(h*sin(theta_r));
  m = sin(theta_r)/cos(theta_r);
  b = y1 - m*x1;
  line(x1, y1, x2, y2);
  
  float xi = x1;
  float yi;
  
  for(int i = 0; i < 201; i = i +1){
    yi = m*xi + b;
    dist = abs(sqrt(sq(xi-mouseX)+sq(yi-mouseY)));
    
    if(dist <= delta){
      if(collision != true) {
        collision = true;
        //send update
        myPort.write("u");
      }
    }
    if(dist > delta) {
      if(collision == true) { 
        collision = false;
        //send update
        myPort.write("d");
      }
    }
    xi = xi + (x2-x1)/201;
  }    
    

  }
  else
  {
     DrawSelectionButtons();
  }
}
//EOF
