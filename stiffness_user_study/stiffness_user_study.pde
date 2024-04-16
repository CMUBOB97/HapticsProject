/**
 ****************************************************************************
 * @file    Haptic Mouse Project for 16-880 
 * @author  lchomas@andrew.cmu.edu
 * @version 1.0
 * @date    April-2024
 * @brief   Sends data to haptic mouse based k value entered
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

void setup()
{
  size(1200, 800);
  setupCom();
  
}


void draw() 
{
  background(255,255,255);
  
  DrawSelectionButtons();
}
//EOF
