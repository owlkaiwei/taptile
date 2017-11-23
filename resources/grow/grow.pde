//imports library for processing to work with the serial port on the computer
import processing.serial.*;


//variable declared for the serial port
Serial myPort;


//these are the image variables used
PImage l_focus, l_laugh, l_mock, l_really, r_focus, r_laugh, r_mock, r_really;


//these are the variables used in the application
float d = 20; //initialises diameter of the ball to 20
float growStep = 30; // This sets the grow size of the balls with each ‘tap’, currently set at 30.
float shrinkStep = 1; // This sets the shrink size of the balls in each loop, currently set at 1.
float rapid_shrinkStep = 20; //This sets the shrink size of the balls when the circumferences of the balls touch, currently set at 20.


int resetSignal = 7;
int mode = 0;


Ball lball, rball;


//this function initializes the application
void setup() {
  // Port name depends on machine. Please find it in the bottom of Arduino IDE.
  //myPort = new Serial(this, "/dev/cu.usbmodem1411", 9600); 
  //set application screen size
  size(1200, 700); 
  //sets color of background
  background(2,16,50); 
  //Disables filling geometry. If both noStroke() and noFill() are called, nothing will be drawn to the screen.  
  noFill();
  noStroke();
  //Draws all geometry with smooth (anti-aliased) edges
  smooth(); 
  //sets the frame rate of the screen
  frameRate(100); 
  //creates new left and right balls with 
  lball = new Ball(width/4, height/2);
  rball = new Ball(3*width/4, height/2);
  textSize(32);
  
  //Loading images for faces in the middle of balls.
  l_focus = loadImage("resources/grow/l_focus.png"); 
  l_laugh = loadImage("resources/grow/l_laugh.png");
  l_mock = loadImage("resources/grow/l_mock.png");
  l_really = loadImage("resources/grow/l_really.png");
  r_focus = loadImage("resources/grow/r_focus.png");
  r_laugh = loadImage("resources/grow/r_laugh.png");
  r_mock = loadImage("resources/grow/r_mock.png");
  r_really = loadImage("resources/grow/r_really.png");;
}


//this function loops and everything in there repeats
void draw() {
  draw_Background();
  
  lball.shrink();
  lball.display();
  rball.shrink();
  rball.display();
  
  //read from serial port
  int id = -1;
  //int id = -1; //used for keyboard control
  //println(id); //prints this out to serial port for debug
  
  //if any part of the screen is pressed, game resets
  if (mousePressed) {
    lball.reset();
    rball.reset();
  }
  
  //if the tiles of Group 1 is pressed, left ball increases in size
  if (id == 0 || id == 1 || id == 2) {
    lball.grow();
    lball.display();
    if (lball.d + rball.d >  width) { //if both balls touches
      rball.rapid_shrink();
      rball.display();
    }
  }
  //if the tiles of Group 2 is pressed, right ball increases in size
  else if (id == 3 || id == 4 || id == 5) {
    //println("right" + id);
    rball.grow();
    rball.display();
    if (lball.d + rball.d > width) { //if both balls touches
      lball.rapid_shrink();
      lball.display();
    }
  }
  
}


//Draws the background and dots.
void draw_Background() {
  fill(255,150+random(100),0+random(255),10);
  rect(0, 0, width, height);
  stroke(255);
  fill(182,164,228);
  stroke(226,193,243);
  float size = random(width/30);
  ellipse(random(width), random(height),size, size);
}


//Faces in the middle of balls.
void draw_Face() {
  if (lball.d < width/8 && rball.d < width/8) { //if both balls are small
    image(l_focus, width/4 - width/16, height/2 - width/16, width/8, width/8);
    image(r_focus, 3* width/4 - width/16, height/2 - width/16, width/8, width/8);
  }
  else if (lball.d > rball.d) { //if left is winning, laugh
    image(l_laugh, width/4 - width/16, height/2 - width/16, width/8, width/8);
    image(r_really, 3* width/4 - width/16, height/2 - width/16, width/8, width/8);
  }
  else { //if right is winning, laugh
    image(l_really, width/4 - width/16, height/2 - width/16, width/8, width/8);
    image(r_laugh, 3* width/4 - width/16, height/2 - width/16, width/8, width/8);
  }
}


//class for ball object 
class Ball {
  float d;
  PVector location;
  
  Ball(int x, int y) {
    d = 200;
    location = new PVector(x, y);
  }
  
  //this function increases the diameter of the balls by growStep  
  void grow() {
    d += growStep;
  }
  
  //this function decreases the diameter of the balls by shrinkStep 
  void shrink() {
    if (d > 200) {
      d -= shrinkStep;
    }
  }
  
  //this function decreases the diameter of the balls by rapid_shrinkStep
  void rapid_shrink() {
    if (d > 200) {
      d -= rapid_shrinkStep;
    }
  }
  
  //this function draws a circle with diameter d at location.x and y
  void display() {
    stroke(255);
    fill(182,164,228, 10);
    ellipse(location.x, location.y, d, d);
  }
  
  //this function resets the diameter of the balls to 0
  void reset() {
    d = 250;
  }
}

// Alternative option for key control. Need to change to switch control.
void keyPressed() {
  if ((lball.d + rball.d < width) && (key == 'a' || key == 's' || key == 'd')) {
    lball.grow();
    lball.display();
    if (lball.d + rball.d > width) {
      rball.rapid_shrink();
      rball.display();
    }
  }
  else if ((lball.d + rball.d < width) && (key == 'j' || key == 'k' || key == 'l')) {
    rball.grow();
    rball.display();
    if (lball.d + rball.d > width) {
      lball.rapid_shrink();
      lball.display();
    }
  }
}