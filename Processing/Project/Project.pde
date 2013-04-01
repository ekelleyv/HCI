// Augmented Reality RGBCube OOP Example by Amnon Owed (21/12/11)
// Processing 1.5.1 + NyARToolkit 1.1.6 + GSVideo 1.0
 
import java.io.*; // for the loadPatternFilenames() function
import processing.opengl.*; // for OPENGL rendering
import codeanticode.gsvideo.*; // the GSVideo library
import com.shigeodayo.pframe.*;


Detect ar_detect;
Capture cam;
Initialize init;
String camPara = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/data/camera_para.dat";
String patternPath = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/patternMaker/examples/ARToolKit_Patterns";
int arWidth = 640;
int arHeight = 480;
boolean init_on = false;

SecondApplet secondApplet = null;
PFrame secondFrame = null;



void setup() {
  //Create display
  // size(displayWidth, displayHeight);
  size(640, 480);
  println("Setting up");


  //Create init object
  init = new Initialize();

  //Create camera object
  String[] cameras = Capture.list();
  println(cameras);
  cam = new Capture(this, cameras[12]);
  cam.start();

    //Create detect object
  ar_detect = new Detect(this, arWidth, arHeight, camPara, patternPath);

  secondApplet = new SecondApplet();
  secondFrame = new PFrame(secondApplet, 210, 0);
  secondFrame.setTitle("Second Frame");

}

// second Processing applet
private class SecondApplet extends PApplet {
  
  void setup() {
    size(1280, 1024);
    background(0);
  }  
  
  void draw() {
    PGraphics pg = createGraphics(width, height);
    pg.beginDraw();
    pg.background(0);
    pg.endDraw();
    init.run(pg);
    image(pg, 0, 0);
  }
  
}

void draw() {
    if (cam.available() == true) {
      cam.read();
      image(cam, 0, 0, width, height);
      ar_detect.run(cam);
      ar_detect.draw_markers();
    }

  }

void keyPressed() {
  init_on = !init_on;
}
