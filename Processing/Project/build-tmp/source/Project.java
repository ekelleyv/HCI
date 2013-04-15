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



public void setup() {
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

public void draw() {
    // init.run();
    assembly.update();
}




public void keyPressed() {
  init_on = !init_on;
}


// second Processing applet
private class DispApplet extends PApplet {
  
  public void setup() {
    size(cam_width, cam_height);
    background(255, 0, 0);
    frameRate(30);
    disp_buffer = createGraphics(cam_width, cam_height);
  } 

  public void draw() {
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
class Assembly {

  int regA;
  int regB;
  int regC;
  int regD;
  int im_width;
  int im_height;
  int[] output;
  int output_count;

  Assembly (int im_width, int int_height) {
    output = new int[10];
    output_count = 0;
    this.im_width = im_width;
    this.im_height = im_height;
    regA = 0;
    regB = 0;
    regC = 0;
    regD = 0;
  }

  public void update() {
    draw_grid();
    update_reg_vals();
    draw_output();
  }

  public void add_output(int val) {
    if (output_count == output.length) {
      output = expand(output);
    }
    output[output_count++] = val;
  }

  public void draw_grid() {
    background(0);
    noFill();

    //Border
    stroke(255);
    strokeWeight(10);
    rect(10, 10, width-15, height-15);

    //Center Line
    fill(255, 255, 255);
    line(width/2-5, 10, width/2-5, height);

    //Code header
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Code", width/4, 40);

    //Memory/Output Line
    line(width/2, height/4, width, height/4);

    text("Output", 3*width/4, height/4 + 40);

    fill(217, 105, 0);
    rect(width/2, 10, width/8-9, height/4-10);
    fill(255, 187, 0);
    rect(5*width/8, 10, width/8-9, height/4-10);
    fill(217, 102, 111);
    rect(6*width/8, 10, width/8-9, height/4-10);
    fill(4, 117, 100);
    rect(7*width/8, 10, width/8-9, height/4-10);


    fill(255);
    text("A", 9*width/16, 40);
    text("B", 11*width/16, 40);
    text("C", 13*width/16, 40);
    text("D", 15*width/16, 40);
  }

  public void update_reg_vals() {
    draw_val(regA, 0);
    draw_val(regB, 1);
    draw_val(regC, 2);
    draw_val(regD, 3);
  }

  public void draw_val(int val, int num) {
    int offset = num*2+9;
    fill(255);
    textSize(64);
    if (val > 1000) {
      textSize(40);
    }
    text(val, offset*width/16, 120);
  }

  public void draw_output() {
    fill(255);
    textSize(32);
    int output_start = output_count - 15;
    if (output_start < 0) {
      output_start = 0;
    }
    for (int i = output_start; i < output_count; i++) {
      text(output[i], width/2+80, height/4+80 + (i-output_start)*32);
    }
  }

}

 // the NyARToolkit Processing library

class Detect {
	MultiMarker nya;
	int cam_width;
	int cam_height;
	int num_markers = 40; //Update to how many markers we use
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

	public void draw_markers(PGraphics pg) {
		for (int i = 0; i < num_markers; i++) {
			if ((!nya.isExistMarker(i))) { continue; } //Continue if marker does not exist

			PVector[] pos2d = nya.getMarkerVertex2D(i);
			// draw each vector both textually and with a red dot
			for (int j=0; j<pos2d.length; j++) {
				String s = j + " : (" + PApplet.parseInt(pos2d[j].x) + "," + PApplet.parseInt(pos2d[j].y) + ")";
				// fill(255);
				// rect(pos2d[j].x, pos2d[j].y, textWidth(s) + 3, textAscent() + textDescent() + 3);
				pg.fill(0);
				pg.text(s, pos2d[j].x + 2, pos2d[j].y + 2);
				pg.fill(255, 0, 0);
				pg.ellipse(pos2d[j].x, pos2d[j].y, 5, 5);
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

	public void generate_display() {
		background(255);
		int x_space = (int)width/(col + 1);
		int y_space = (int)height/(row + 1);
		for (int i = 0; i < row; i++) {
			for (int j = 0; j < col; j++) {
				image(ar_images.get((i*col) + j), (j + 1)*x_space - marker_width/2, (i + 1)*y_space - marker_width/2, marker_width, marker_width);
			}
		}
	}
}
class Initialize {
	Grid init_grid;

	Initialize() {
		init_grid = new Grid(5, 5, 80);
	}

	public void run () {
		int start = millis();
		int init_length = 10000;
		init_grid.generate_display();
	}
}
// public enum TagType {
// 	LITERAL,
// 	INSTRUCTION,
// 	META
// }

// class Tag {
// 	int id;
// 	int type;

// 	Tag(id) {
// 		this.id = id;
// 	}

// 	get_type() {
// 		type = 
// 		if (id <=16) {

// 		}
// 	}
// }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Project" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
