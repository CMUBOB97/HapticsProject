/**
 ****************************************************************************
 * @file    ProcessingTemplate 
 * @author  mortamar@andrew.cmu.edu
 * @version 1.0
 * @date    Feburary-2020
 * @brief   This example is used to receive the cursor position from Haplink
 *           1-DOF and display it as a small circle on the screen.
 ****************************************************************************
 */


int windowlength = 800; //these have to match the window width and length declared in size
int windowwidth = 800;

final int LINE = 1;
final int PARABOLA = 2;

int cursorX = 0; // X position in pixels
int cursorY = 0; // Y position in pixels
int boxXmin = 0; // X position of box in pixels
int boxXmax = 0; // X position of box in pixels
int boxYmin = 0; // Y position of box in pixels
int boxYmax = 0; // Y position of box in pixels

int cursorSize = 20; //size of the Haplink cursor in pixels
float cursorX_mm = 0; //X position in mm
float cursorY_mm = 0; //Y position in mm

// box dimensions
float boxXcenter_mm = -36.327652;
float boxYcenter_mm = 142.337051;
float boxlength_mm = 20.0;
float boxXmin_mm = boxXcenter_mm - boxlength_mm / 2; // X position of box in mm
float boxXmax_mm = boxXcenter_mm + boxlength_mm / 2; // X position of box in mm
float boxYmin_mm = boxYcenter_mm - boxlength_mm / 2; // Y position of box in mm
float boxYmax_mm = boxYcenter_mm + boxlength_mm / 2; // Y position of box in mm

// record which way it enters the wall
int contact_made = 0;

int sayHiForFirstTime = 0;

void setup()
{
  size(800, 800); //make our canvas 800 x 800 pixels big
  setupCom(); // com selection interface
  setupShape(); // shape selection interface
}


void draw() 
{
  background(255,255,255);
  
  if (myPort != null)
  {
    //say hi to Nucleo
    if (sayHiForFirstTime ==0)
    {
      myPort.write("1l");
      sayHiForFirstTime = 1;
    }
 
    //request Data
    myPort.write("3l"); //send message to request data from Nucleo

    //check if data is available:
    if (myPort.available() > 0) 
    {
      // If data is available, and have received all of it!
      messageSize = myPort.readBytes(messageBuffer);
    
      //if message isn't empty:
      if (messageSize > 0)
      {
         String messageString = new String(messageBuffer);
         //split the message into values
         vals = float(splitTokens(messageString, "\t"));
         
         //TBD: do we need data from STM32?
         
         //just received data, send acknowledgment:
         myPort.write("1l");
      }
   
    } 

    // ----> draw your virtual environment here!
    
    // case on shape rendered
    switch(shape_list[shape_selected]) {
      case LINE:
        stroke(0);
        line(200, 200, 600, 600);
        break;
      case PARABOLA:
        stroke(0);
        break;
      default:
        break;
    }
    
    //draw the lines in black
    stroke(0);
    //draw Haplink cursor as a ball
    fill(127,255,212); 
    ellipse(mouseX, mouseY, cursorSize, cursorSize);
    //draw Haplink cursor as a dot:
    fill(0);
    ellipse(mouseX, mouseY, 2, 2);
    
    //Don't edit past here
  }
  else
  {
     DrawSelectionButtons();
     DrawShapeButtons();
     sayHiForFirstTime=0; 
  }
}
//EOF
