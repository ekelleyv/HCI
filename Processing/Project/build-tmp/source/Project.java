import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.io.*; 
import processing.opengl.*; 
import codeanticode.gsvideo.*; 
import com.shigeodayo.pframe.*; 
import processing.video.*; 
import jp.nyatla.nyar4psg.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Project extends PApplet {

// Augmented Reality RGBCube OOP Example by Amnon Owed (21/12/11)
// Processing 1.5.1 + NyARToolkit 1.1.6 + GSVideo 1.0
 
 // for the loadPatternFilenames() function
 // for OPENGL rendering
 // the GSVideo library



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



public void setup() {
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
  
  public void setup() {
    size(1280, 1024);
    background(0);
  }  
  
  public void draw() {
    PGraphics pg = createGraphics(width, height);
    pg.beginDraw();
    pg.background(0);
    pg.endDraw();
    init.run(pg);
    image(pg, 0, 0);
  }
  
}

public void draw() {
    if (cam.available() == true) {
      cam.read();
      image(cam, 0, 0, width, height);
      ar_detect.run(cam);
      ar_detect.draw_markers();
    }

  }

public void keyPressed() {
  init_on = !init_on;
}

 // the NyARToolkit Processing library

class Detect {
	MultiMarker nya;
	int cam_width;
	int cam_height;
	int num_markers = 10; //Update to how many markers we use
	String cam_param;
	String pattern_filepath;
	String[] patterns; 

	Detect (Project project, int cam_width, int cam_height, String cam_param, String pattern_filepath) {
		this.cam_width = cam_width;
		this.cam_height = cam_height;
		this.cam_param = cam_param;
		this.pattern_filepath = pattern_filepath;
		// initialize the MultiMarker at a specific resolution (make sure to input images for detection EXACTLY at this resolution)
		this.nya = new MultiMarker(project, cam_width, cam_height, cam_param, NyAR4PsgConfig.CONFIG_DEFAULT);

		setup();
	}

	public void setup() {
		//Set delay for determining tag "lost"
		nya.setLostDelay(1);
		String[] patterns = loadPatternFilenames(pattern_filepath);

		for (int i=0; i<num_markers; i++) {
			nya.addARMarker(patternPath + "/" + patterns[i], 80);
		}
	}

	public void run (PImage cam_image) {

		nya.detect(cam_image);
	}

	public void draw_markers() {
		for (int i = 0; i < num_markers; i++) {
			if ((!nya.isExistMarker(i))) { continue; } //Continue if marker does not exist

			PVector[] pos2d = nya.getMarkerVertex2D(i);
			// draw each vector both textually and with a red dot
			for (int j=0; j<pos2d.length; j++) {
				String s = j + " : (" + PApplet.parseInt(pos2d[j].x) + "," + PApplet.parseInt(pos2d[j].y) + ")";
				// fill(255);
				// rect(pos2d[j].x, pos2d[j].y, textWidth(s) + 3, textAscent() + textDescent() + 3);
				fill(0);
				text(s, pos2d[j].x + 2, pos2d[j].y + 2);
				fill(255, 0, 0);
				ellipse(pos2d[j].x, pos2d[j].y, 5, 5);
			}
		}
	}

	// this function loads .patt filenames into a list of Strings based on a full path to a directory (relies on java.io)
	public String[] loadPatternFilenames(String path) {
		File folder = new File(path);
		FilenameFilter pattFilter = new FilenameFilter() {
			public boolean accept(File dir, String name) {
				return name.toLowerCase().endsWith(".patt");
			}
		};
		return folder.list(pattFilter);
	}
}
class Grid {
	int row;
	int col;
	int marker_width;
	ArrayList <PImage> ar_images;

	Grid(int row, int col, int marker_width) {
		this.row = row;
		this.col = col;
		this.marker_width = marker_width;
		this.ar_images = new ArrayList <PImage> ();

		setup();
	}

	public void setup() {
		String image_prefix = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/patternMaker/examples/gif/4x4_384_";
		//Load images
		int num_images = row*col;

		for (int i = 1; i < (num_images+1); i++) {
			ar_images.add(loadImage(image_prefix + i + ".gif"));
		}
	}

	public void generate_display(PGraphics pg) {
		pg.beginDraw();
		pg.background(255);
		int x_space = (int)width/(col + 1);
		int y_space = (int)height/(row + 1);
		for (int i = 0; i < row; i++) {
			for (int j = 0; j < col; j++) {
				pg.image(ar_images.get((i*col) + j), (j + 1)*x_space - marker_width/2, (i + 1)*y_space - marker_width/2, marker_width, marker_width);
			}
		}
		pg.endDraw();
	}
}
class Initialize {
	Grid init_grid;

	Initialize() {
		init_grid = new Grid(5, 5, 80);
	}

	public void run(PGraphics pg) {
		int start = millis();
		int init_length = 10000;
		// init_grid.generate_display(pg);
	}
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Project" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
