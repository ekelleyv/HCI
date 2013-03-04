import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Grid extends PApplet {

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
	}

	public void display() {
		String image_prefix = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/patternMaker/examples/gif/4x4_384_";
		//Load images
		int num_images = row*col;

		for (int i = 0; i < num_images; i++) {
			ar_images.add(loadImage(image_prefix + i + ".gif"));
			printn("Test");
		}
	}
}

public void setup() {
	Grid init_grid = new Grid(5, 5, 20);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Grid" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
