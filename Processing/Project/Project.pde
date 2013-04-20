
import java.io.*; // for the loadPatternFilenames() function
import processing.opengl.*; // for OPENGL rendering
import codeanticode.gsvideo.*; // the GSVideo library
import com.shigeodayo.pframe.*; // the PFrame library


Detect ar_detect;
Capture cam;
Initialize init;
String camPara;
String patternPath;

boolean iSight = true;
int cam_number;

int cam_width;
int cam_height;

// Projector Display Dimensions
int proj_width = 1280;
int proj_height = 1024;

// Init variables
boolean init_on = false;
int init_count = 0;
int init_length = 30;

DispApplet disp_applet;
PFrame disp_frame;
PGraphics proj_buffer;
PGraphics disp_buffer;
TagLibrary tags;
Translate trans = new Translate();

// Application application = new RootApplication();



void setup() {

  if (iSight) {
    cam_width = 640;
    cam_height = 480;
    cam_number = 0;
  }
  else {
    cam_width = 1280;
    cam_height = 960;
    cam_number = 12;
  }
  //Create display
  camPara = sketchPath("../libraries/nyar4psg/data/camera_para.dat");
  patternPath = sketchPath("../libraries/nyar4psg/patternMaker/examples/ARToolKit_Patterns");

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
  cam = new Capture(this, cameras[cam_number]);
  cam.start();

  // Create required objects
  ar_detect = new Detect(this, cam_width, cam_height, camPara, patternPath);
  init = new Initialize();
  tags = new TagLibrary();

  // application.init(proj_width, proj_height);

}

void draw() {
    // Tag detection and update buffer
    if (cam.available() == true) {
      cam.read();
      tags = ar_detect.detect_tags(cam);
    }

    if (init_on) {
      if (init_count < init_length) {
        init.generate_display();
        init_count++;
      }
      else {
        init_count = 0;
        init_on = false;
        init.addProjectorCorners(tags);
        trans.init(tags);
      }
    }
    else {
      background(0);
      // application.update(tags);
    }
}
void keyPressed() {
  if (key == 'i' || key == 'I') {
    init_on = true;
    init_count = 0;
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
    disp_buffer.endDraw();

    // tags.drawCam(disp_buffer);

    image(disp_buffer, 0, 0);
  }
}
