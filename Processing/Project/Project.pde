// Augmented Reality RGBCube OOP Example by Amnon Owed (21/12/11)
// Processing 1.5.1 + NyARToolkit 1.1.6 + GSVideo 1.0
 
import java.io.*; // for the loadPatternFilenames() function
import processing.opengl.*; // for OPENGL rendering
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library
import codeanticode.gsvideo.*; // the GSVideo library
import processing.video.*;

boolean show_video = true;
MultiMarker nya;
// GSCapture cam;
Capture cam;

 // this is the arraylist that holds all the objects
ArrayList <ARObject> ars = new ArrayList <ARObject> ();


// a central location is used for the camera_para.dat and pattern files, so you don't have to copy them to each individual sketch
// Make sure to change both the camPara and the patternPath String to where the files are on YOUR computer
// the full path to the camera_para.dat file
String camPara = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/data/camera_para.dat";
// the full path to the .patt pattern files
String patternPath = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/patternMaker/examples/ARToolKit_Patterns";
// the dimensions at which the AR will take place. with the current library 1280x720 is about the highest possible resolution.
int arWidth = 640;
int arHeight = 480;
// the number of pattern markers (from the complete list of .patt files) that will be detected, here the first 10 from the list.
int numMarkers = 10;
// the maximum rotation speed (x, y, z) at which the RGBCubes will rotate
float mS = 0.2;

Initialize init;

boolean init_on = false;

void setup() {
  size(displayWidth, displayHeight);
  // size(640, 480);
  // background(0);
  init = new Initialize();
  // init_grid = new Grid(5, 5, 80);
  String[] cameras = Capture.list();

  println(cameras[12]);
  println("camera " + cameras.length);
  cam = new Capture(this, cameras[0]);
  cam.start();

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
 
// void setup() {
//   size(640, 480, OPENGL); // the sketch will resize correctly, so for example setting it to 1920 x 1080 will work as well
//   cam = new GSCapture(this, 640, 480); // initialize the webcam capture at a specific resolution (correct and/or possible settings depend on YOUR webcam)
//   cam.start(); // start capturing
//   // initialize the MultiMarker at a specific resolution (make sure to input images for detection EXACTLY at this resolution)
//   nya = new MultiMarker(this, arWidth, arHeight, camPara, NyAR4PsgConfig.CONFIG_DEFAULT);
//   // set the delay after which a lost marker is no longer displayed. by default set to something higher, but here manually set to immediate.
//   nya.setLostDelay(1);
//   // load the pattern filenames (markers)
//   String[] patterns = loadPatternFilenames(patternPath);
//   // for the selected number of markers...
//   for (int i=0; i<numMarkers; i++) {
//     // add the marker for detection
//     nya.addARMarker(patternPath + "/" + patterns[i], 80);
//     // and create an ARObject with the corresponding 'ID'
//     ars.add(new ARObject(i));
//   }
//   // set the color range to 1 (instead of 255), saves typing for the coloring of the cube
//   colorMode(RGB, 1);
//   // turn off stroke for the rest of the sketch
//   noStroke();
// }
 
// void draw() {
//   // if there is a cam image coming in...
//   if (cam.available()) {
//     cam.read(); // read the cam image

//     if (show_video) {
//       background(cam); // a background call is needed for correct display of the marker results
//       // image(cam, 0, 0, width, height); // display the image at the width and height of the sketch window
//       // create a copy of the cam image at the resolution of the AR detection (otherwise nya.detect will throw an assertion error!)

//       PImage cSmall = cam.get();
//       cSmall.resize(arWidth, arHeight);
//       nya.detect(cam); // detect markers in the image
//       // set the AR perspective uniformly, this general point-of-view is the same for all markers
//       nya.setARPerspective();
//       // run all the ARObjects's in the arraylist => most things are handled inside the ARObject (see the class for more info)
//       for (ARObject ar : ars) { 
//         ar.run();
//       }

//       // reset to the default perspective
//       perspective();
//     }
//     else {
//       background(cam);
//       nya.detect(cam); 
//       drawMarkers();
//     }
//   }
// }

// // this function draws the marker coordinates, note that this is completely 2D and based on the AR dimensions (not the final display size)
// void drawMarkers() {
//   // set the text alignment (to the left) and size (small)
//   textAlign(LEFT, TOP);
//   textSize(10);
//   noStroke();
//   // scale from AR detection size to sketch display size (changes the display of the coordinates, not the values)
//   // for all the markers...
//   for (int i=0; i<numMarkers; i++) {
//     // if the marker does NOT exist (the ! exlamation mark negates it) continue to the next marker, aka do nothing
//     if ((!nya.isExistMarker(i))) { continue; }
//     // the following code is only reached and run if the marker DOES EXIST
//     // get the four marker coordinates into an array of 2D PVectors
//     PVector[] pos2d = nya.getMarkerVertex2D(i);
//     // draw each vector both textually and with a red dot
//     for (int j=0; j<pos2d.length; j++) {
//       String s = j + " : (" + int(pos2d[j].x) + "," + int(pos2d[j].y) + ")";
//       fill(255);
//       rect(pos2d[j].x, pos2d[j].y, textWidth(s) + 3, textAscent() + textDescent() + 3);
//       fill(0);
//       text(s, pos2d[j].x + 2, pos2d[j].y + 2);
//       fill(255, 0, 0);
//       ellipse(pos2d[j].x, pos2d[j].y, 5, 5);
//     }
//   }
// }
 
// // this function loads .patt filenames into a list of Strings based on a full path to a directory (relies on java.io)
// String[] loadPatternFilenames(String path) {
//   File folder = new File(path);
//   FilenameFilter pattFilter = new FilenameFilter() {
//     public boolean accept(File dir, String name) {
//       return name.toLowerCase().endsWith(".patt");
//     }
//   };
//   return folder.list(pattFilter);
// }