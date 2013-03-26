// Augmented Reality RGBCube OOP Example by Amnon Owed (21/12/11)
// Processing 1.5.1 + NyARToolkit 1.1.6 + GSVideo 1.0
 
import java.io.*; // for the loadPatternFilenames() function
import processing.opengl.*; // for OPENGL rendering
import codeanticode.gsvideo.*; // the GSVideo library

Detect ar_detect;
Capture cam;
Initialize init;
String camPara = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/data/camera_para.dat";
String patternPath = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/patternMaker/examples/ARToolKit_Patterns";
int arWidth = 640;
int arHeight = 480;
boolean init_on = false;



void setup() {
  //Create display
  size(displayWidth, displayHeight);
  println("Setting up");

  //Create init object
  init = new Initialize();

  //Create camera object
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[0]);
  cam.start();

  //Create detect object
  ar_detect = new Detect(this, arWidth, arHeight, camPara, patternPath);

}

void draw() {
  // init_grid.display();
  if (!init_on) {
    if (cam.available() == true) {
      cam.read();
    }
    background(0);
    image(cam, 0, 0, width, height);
  }
  else {
    init.run();
  }
}

void keyPressed() {
  init_on = !init_on;
}
