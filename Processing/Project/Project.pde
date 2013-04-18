
import java.io.*; // for the loadPatternFilenames() function
import processing.opengl.*; // for OPENGL rendering
import codeanticode.gsvideo.*; // the GSVideo library
import com.shigeodayo.pframe.*; // the PFrame library

String camPara = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/data/camera_para.dat";
String patternPath = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/patternMaker/examples/ARToolKit_Patterns";

// Camera Dimensions
int cam_width = 1280;
int cam_height = 960;

// Projector Display Dimensions
int proj_width = 1280;
int proj_height = 1024;

boolean init_on = false;

DispApplet disp_applet;
PFrame disp_frame;
Detect ar_detect;
Capture cam;
Initialize init;
PGraphics proj_buffer;
PGraphics disp_buffer;
TagLibrary tags;
Assembly assembly;



void setup() {
  //Create display
  println("Setting Up Projector Display");
  size(proj_width, proj_height);
  frameRate(30);
  frame.setTitle("Projector");

  // Setting Up Monitor
  disp_buffer = createGraphics(cam_width, cam_height);
  disp_applet = new DispApplet();
  disp_frame = new PFrame(disp_applet, 210, 0);
  disp_frame.setTitle("Display");

  //Create camera object
  println("Setting Up Camera");
  String[] cameras = Capture.list();
  println(cameras);
  cam = new Capture(this, cameras[12]); // 0 is iSight 12 is USB
  cam.start();

  // Create required objects
  ar_detect = new Detect(this, cam_width, cam_height, camPara, patternPath);
  init = new Initialize();
  tags = new TagLibrary();
  assembly = new Assembly(proj_width, proj_height);

}

void draw() {
    // Tag detection and update buffer
    if (cam.available() == true) {
      cam.read();
      tags = ar_detect.detect_tags(cam);
    }

    if (init_on) {

    }

    //get_translation();
    //assembly.update();
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
  }

  void draw() {
    image(disp_buffer, 0, 0);
    disp_buffer.beginDraw();
    disp_buffer.image(cam, 0, 0, cam_width, cam_height);
    ar_detect.draw_tags(tags, disp_buffer);
    disp_buffer.endDraw();
  }
}
