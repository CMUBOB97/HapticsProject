/**
 ****************************************************************************
 * @file    Haptic Mouse Project for 16-880 
 * @author  lchomas@andrew.cmu.edu
 * @version 1.0
 * @date    April-2024
 * @brief   Sends data to haptic mouse based on collision of cursor with line
 ****************************************************************************
 */

int cursorSize = 10; //size of the cursor in pixels

int h = 500;
float x1, y1, x2, y2;
float m, b;
float DELTA = 2; // tolerance around line that constitutes a collision
float dist;
float theta_r;

boolean collision = false;
boolean collision_old = false;

color line_color;

void setup()
{
  size(1200, 800);
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
  
  y1 = 200;
  if(theta < 0) {
    y1 = 600;
  }
  if(theta == 0){
    y1 = 400;
  }
  x1 = 500;
  x2 = x1 + round(h*cos(theta_r));
  y2 = y1 + round(h*sin(theta_r));
  m = sin(theta_r)/cos(theta_r);
  b = y1 - m*x1;
  stroke(line_color);
  line(x1, y1, x2, y2);
  
  float xi = x1;
  float yi;

    int i = 0;
    collision = false;
    while(i < 201){
      yi = m*xi + b;
      dist = abs(sqrt(sq(xi-mouseX)+sq(yi-mouseY)));
      
      if(dist <= DELTA){
        collision = true;
      }

      xi = xi + (x2-x1)/201;
      
      i = i +1;
    } // while  
  
    if(collision && !collision_old) {
      //send update
      myPort.write("u");
      line_color = color(255, 0, 0);
    }
    
    if(!collision && collision_old) { 
      //send update
      myPort.write("d");
      line_color = color(0, 0, 0);
    }
    collision_old = collision;
    collision = false;  
 
  }
  else
  {
     DrawSelectionButtons();
  }
}
//EOF
