import processing.serial.*;
import processing.event.*;
Serial myPort;  // Create object from Serial class

float[] vals = {};
boolean dataReceived = false;
byte [] messageBuffer = new byte[100];
int messageSize = 0;


textBox k;                         // text box for entering k
String k_s = "";                   // string form of k

// serial port buttons
Button btn_serial_up;              // move up through the serial port list
Button btn_serial_dn;              // move down through the serial port list
Button btn_serial_connect;         // connect to the selected serial port
Button btn_serial_disconnect;      // disconnect from the serial port
Button btn_serial_list_refresh;    // refresh the serial port list
String serial_list;                // list of serial ports
int serial_list_index = 0;         // currently selected serial port 
int num_serial_ports = 0;          // number of serial ports in the list
String portInfo;

void setupCom()
{
  // create the buttons
  btn_serial_up = new Button("^", 140, 10, 40, 20);
  btn_serial_dn = new Button("v", 140, 50, 40, 20);
  btn_serial_connect = new Button("Connect", 190, 10, 100, 25);
  btn_serial_disconnect = new Button("Disconnect", 190, 45, 100, 25);
  btn_serial_list_refresh = new Button("Refresh", 190, 80, 100, 25);
  portInfo = " - Disconn";
  
  // create k value text box
  k = new textBox(190, 125, 100, 25);

  // get the list of serial ports on the computer
  serial_list = Serial.list()[serial_list_index];
  println(Serial.list());
  println(Serial.list().length);

  // get the number of serial ports in the list
  num_serial_ports = Serial.list().length;
}


void DrawSelectionButtons()
{
  btn_serial_up.Draw();
  btn_serial_dn.Draw();
  btn_serial_connect.Draw();
  btn_serial_disconnect.Draw();
  btn_serial_list_refresh.Draw();
  
  // Draw k text box
  k.Draw(k_s);

  // draw the text box containing the selected serial port
  DrawTextBox("Select Port", serial_list + portInfo, 10, 10, 120, 60);
}

// function for drawing a text box with title and contents
void DrawTextBox(String title, String str, int x, int y, int w, int h)
{
  fill(255);
  rect(x, y, w, h);
  fill(0);
  textAlign(LEFT);
  textSize(14);
  text(title, x + 10, y + 10, w - 20, 20);
  textSize(12);  
  text(str, x + 10, y + 40, w - 20, h - 10);
}

void mousePressed() {
  // up button clicked
  if (btn_serial_up.MouseIsOver()) {
    if (serial_list_index > 0) {
      // move one position up in the list of serial ports
      serial_list_index--;
      serial_list = Serial.list()[serial_list_index];
    }
  }
  // down button clicked
  if (btn_serial_dn.MouseIsOver()) {
    if (serial_list_index < (num_serial_ports - 1)) {
      // move one position down in the list of serial ports
      serial_list_index++;
      serial_list = Serial.list()[serial_list_index];
    }
  }
  // Connect button clicked
  if (btn_serial_connect.MouseIsOver()) {
    if (myPort == null) {
      // connect to the selected serial port
      myPort = new Serial(this, Serial.list()[serial_list_index], 9600);
      portInfo = " - Conn";
    }
  }
  // Disconnect button clicked
  if (btn_serial_disconnect.MouseIsOver()) {
    if (myPort != null) {
      // disconnect from the serial port
      myPort.stop();
      myPort = null;
      println("Stopped COM");
      portInfo = " - Disconn";
    }
  }
  // Refresh button clicked
  if (btn_serial_list_refresh.MouseIsOver()) {
    // get the serial port list and length of the list
    serial_list = Serial.list()[serial_list_index];
    num_serial_ports = Serial.list().length;
  }
}

void keyPressed() {
  // if key is number, type on screen and save
  if(int(key) >= 48 && int(key) <= 57) {
    k_s = k.Type(str(key), k_s);
  }
  
  // if enter pressed, send k value to STM32
  if(key == ENTER) {
    //char[] k_s_array = k_s.toCharArray();
    myPort.write(k_s);
    println(k_s);
    //myPort.write(k_s_array[1]);
    print("sent\n");
    k_s = "";
  }
  
  // reset the serial com if 'r' is pressed
  if (key == 'r') {
    myPort.stop();
    myPort = null;
    println("Stopped COM");
    portInfo = " - Disconn";
    k_s = "";
  }
}


// button class used for all buttons
class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button

  // constructor
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }

  // draw the button in the window
  void Draw() {
    fill(218);
    stroke(141);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }

  // returns true if the mouse cursor is over the button
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}

class textBox {
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button

  // constructor
  textBox(float xpos, float ypos, float widthB, float heightB) {
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }
  
    // draw the text box in the window
  void Draw(String s) {
    fill(218);
    stroke(141);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    text(s, x + (w / 2), y + (h / 2));
  }

  String Type(String c, String s_in) {
    String s = s_in + c;
    return s;
  }
  
  // returns true if the mouse cursor is over the button
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}
