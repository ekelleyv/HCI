import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import hypermedia.video.*; 
import java.awt.Rectangle; 
import codeanticode.gsvideo.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FaceDetection extends PApplet {

// Combining GSVideo capture with the OpenCV library for face detection
// http://ubaa.net/shared/processing/opencv/




OpenCV opencv;
GSCapture cam;

// Contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;

public void setup() {
  size(640, 480);
    
  cam = new GSCapture(this, 640, 480);
  cam.start();

  opencv = new OpenCV(this);

  opencv.allocate(640,480);   
  
  // Load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  

  // Print usage
  println("Drag mouse on X-axis inside this sketch window to change contrast");
  println("Drag mouse on Y-axis inside this sketch window to change brightness");
}

public void captureEvent(GSCapture c) {
  c.read();
}

public void stop() {
  opencv.stop();
  super.stop();
}

public void draw() {
  opencv.copy(cam);
    
  opencv.convert(GRAY);
  opencv.contrast(contrast_value);
  opencv.brightness(brightness_value);

  // Proceed with detection
  Rectangle[] faces = opencv.detect(1.2f, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40);

  // Display the image
  image(cam, 0, 0);

  // Draw face area(s)
  noFill();
  stroke(255, 0, 0);
  for(int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height); 
  }
}

// Changes contrast/brigthness values
public void mouseDragged() {
  contrast_value   = PApplet.parseInt(map(mouseX, 0, width, -128, 128));
  brightness_value = PApplet.parseInt(map(mouseY, 0, width, -128, 128));
}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FaceDetection" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
