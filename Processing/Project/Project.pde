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


int cam_width = 1280;
int cam_height = 960;

int proj_width = 1280;
int proj_height = 1024;
boolean init_on = false;

DispApplet disp_applet = null;
PFrame disp_frame = null;

PGraphics proj_buffer;
PGraphics disp_buffer;

Assembly assembly;



void setup() {
  //Create display
  size(proj_width, proj_height);
  println("Setting up");
  frameRate(30);
  frame.setTitle("Projector");


  //Create init object
  init = new Initialize();

  //Create camera object
  String[] cameras = Capture.list();
  println(cameras);
  cam = new Capture(this, cameras[12]); //0 is iSight 12 is USB
  cam.start();

    //Create detect object
  ar_detect = new Detect(this, cam_width, cam_height, camPara, patternPath);

  disp_applet = new DispApplet();
  disp_frame = new PFrame(disp_applet, 210, 0);
  disp_frame.setTitle("Display");

  assembly = new Assembly(proj_width, proj_height);

}

void draw() {
    // init.run();
    assembly.update();
}




void keyPressed() {
  init_on = !init_on;
}


// second Processing applet
private class DispApplet extends PApplet {
  
  void setup() {
    size(cam_width, cam_height);
    background(255, 0, 0);
    frameRate(30);
    disp_buffer = createGraphics(cam_width, cam_height);
  } 

  void draw() {
    if (cam.available() == true) {
      disp_buffer.beginDraw();
      cam.read();
      disp_buffer.image(cam, 0, 0, cam_width, cam_height);
      ar_detect.run(cam);
      ar_detect.draw_markers(disp_buffer);
      disp_buffer.endDraw();
      image(disp_buffer, 0, 0);
    }

  }
  
}