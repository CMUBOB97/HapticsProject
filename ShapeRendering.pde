/**
 ****************************************************************************
 * @file    ShapeRendering
 * @author  chigandrew.cmu.edu
 * @version 1.0
 * @date    April-2024
 * @brief   This is the main Processing pipeline to
            render the geometry and send rendering signal
            to STM32.
 ****************************************************************************
 */


int windowlength = 800; //these have to match the window width and length declared in size
int windowwidth = 800;

final int LINE = 1;
final int PARABOLA = 2;

int cursorSize = 20; //size of the Haplink cursor in pixels

// record square dimensions here
final int SQUARE_X_MIN = 200;
final int SQUARE_X_MAX = 400;
final int SQUARE_Y_MIN = 200;
final int SQUARE_Y_MAX = 400;

// check the current environment rendering status
boolean render_on = false;

// check the current acknowledgement from STM32
boolean data_received = false;

// helper function to check if the cursor is in the box
boolean check_in_box() {
  boolean x_in = (mouseX >= SQUARE_X_MIN) && (mouseX <= SQUARE_X_MAX);
  boolean y_in = (mouseY >= SQUARE_Y_MIN) && (mouseY <= SQUARE_Y_MAX);
  return x_in && y_in;
}

// setup phase for communication and shape selection
void setup()
{
  size(800, 800); //make our canvas 800 x 800 pixels big
  setupCom(); // com selection interface
  setupShape(); // shape selection interface
}

void draw() 
{
  background(255,255,255);
  
  // if USB serial is connected
  if (myPort != null) {
    
    // case on shape rendered
    switch(shape_list[shape_selected]) {
      case LINE:
        stroke(0);
        fill(17, 149, 255);
        square(200, 200, 200);
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
    
    // check if mouse is in the box
    boolean is_in_box = check_in_box();
    
    // check if STM32 requested to turn on
    if (data_received) {
      //draw the lines in black
      stroke(0);
      //draw indicator as a ball
      fill(255, 114, 51); 
      ellipse(600, 600, cursorSize, cursorSize);
    }
    
    // if enter the box the first time, send turn on rendering message
    if (render_on == false && is_in_box == true) {
      myPort.write("u");
      render_on = true;
    }
    // if exit the box the first time, send turn off rendering message
    if (render_on == true && is_in_box == false) {
      myPort.write("d");
      render_on = false;
    }
    
    //check if data is available on serial:
    if (myPort.available() > 0) 
    {
      
      // check message received from STM32
      messageSize = myPort.readBytes(messageBuffer);
      
      //if message isn't empty:
      if (messageSize > 0)
      {
        String messageString = new String(messageBuffer);
        
        // check to render a smaller box indicating acknowledgement
        if (messageString.charAt(0) == '1') {
          data_received = true;
        } else {
          data_received = false;
        }
      }
    }
  } else {
     DrawSelectionButtons();
     DrawShapeButtons();
  }
}
//EOF
