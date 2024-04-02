import processing.event.*;

int[] shape_list = {LINE, PARABOLA};
String[] shape_names = {"line", "parabola"};
int shape_selected = 0;
int num_shapes = 2;

// shape buttons
Button btn_shape_up;              // move up through the shape list
Button btn_shape_dn;              // move down through the shape list

void setupShape()
{
  // create the buttons
  btn_shape_up = new Button("^", 540, 10, 40, 20);
  btn_shape_dn = new Button("v", 540, 50, 40, 20);
}


void DrawShapeButtons()
{
  btn_shape_up.Draw();
  btn_shape_dn.Draw();

  // draw the text box containing the selected shape
  DrawShapeTextBox("Select Shape", shape_names[shape_selected], 400, 10, 120, 60);
}

// function for drawing a text box with title and contents
void DrawShapeTextBox(String title, String str, int x, int y, int w, int h)
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
