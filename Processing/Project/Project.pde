
import java.io.*; // for the loadPatternFilenames() function
import processing.opengl.*; // for OPENGL rendering
import codeanticode.gsvideo.*; // the GSVideo library
import com.shigeodayo.pframe.*;


Detect ar_detect;
Capture cam;
Initialize init;
String camPara;
String patternPath;


int cam_width = 1280;
int cam_height = 960;

int proj_width = 1280;
int proj_height = 1024;

// Init variables
boolean init_on = false;
int init_count = 0;
int init_length = 30;

DispApplet disp_applet = null;
PFrame disp_frame = null;

PGraphics proj_buffer;
PGraphics disp_buffer;

TagLibrary tags;

Application application = new RootApplication();



void setup() {
  //Create display
  camPara = sketchPath("../libraries/nyar4psg/data/camera_para.dat");
  patternPath = sketchPath("../libraries/nyar4psg/patternMaker/examples/ARToolKit_Patterns");

  size(proj_width, proj_height);
  println("Setting up");
  frameRate(30);
  frame.setTitle("Projector");


  //Create init object
  init = new Initialize();

  //Create camera object
  String[] cameras = Capture.list();
  println(cameras);
  cam = new Capture(this, cameras[0]); //0 is iSight 12 is USB
  cam.start();

    //Create detect object
  ar_detect = new Detect(this, cam_width, cam_height, camPara, patternPath);


  disp_buffer = createGraphics(cam_width, cam_height);
  disp_applet = new DispApplet();
  disp_frame = new PFrame(disp_applet, 210, 0);
  disp_frame.setTitle("Display");

  tags = new TagLibrary();

  application.init(proj_width, proj_height);

}

void draw() {
    //Tag detection and update buffer
    if (cam.available() == true) {
      cam.read();
      tags = ar_detect.detect_tags(cam);
    }

    if (init_on) {
      if (init_count < init_length) {
        
      }
    }
    else {
      application.update(tags);
    }
}


void keyPressed() {
  if (key == 'i' || key == 'I') {
    init_on = True;
  }
}


// second Processing applet
private class DispApplet extends PApplet {
  void setup() {
    size(cam_width, cam_height);
    background(255, 0, 0);
    frameRate(30);
  }

  void draw() {
    disp_buffer.beginDraw();
    disp_buffer.image(cam, 0, 0, cam_width, cam_height);
    tags.drawCam(disp_buffer);
    disp_buffer.endDraw();

    image(disp_buffer, 0, 0);
  }
}
