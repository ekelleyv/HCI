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
import java.util.*; 
import processing.core.PApplet; 
import processing.core.PVector; 
import Jama.*; 
import java.util.List; 
import java.util.ArrayList; 
import java.util.Hashtable; 
import java.io.*; 
import java.util.*; 
import java.util.*; 
import java.util.*; 
import processing.video.*; 
import jp.nyatla.nyar4psg.*; 

import Jama.util.*; 
import Jama.*; 
import Jama.test.*; 
import Jama.examples.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Project extends PApplet {


 // for the loadPatternFilenames() function
 // for OPENGL rendering
 // the GSVideo library



Detect ar_detect;
Capture cam;
Initialize init;
String camPara;
String patternPath;

boolean iSight = true;
int cam_number;

int cam_width;
int cam_height;

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

// Application application = new RootApplication();



public void setup() {

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

  size(proj_width, proj_height);
  println("Setting up");
  frameRate(30);
  frame.setTitle("Projector");


  //Create init object
  init = new Initialize();

  //Create camera object
  String[] cameras = Capture.list();
  println(cameras);
  cam = new Capture(this, cameras[cam_number]);
  cam.start();

  // Create detect object
  ar_detect = new Detect(this, cam_width, cam_height, camPara, patternPath);


  disp_buffer = createGraphics(cam_width, cam_height);
  disp_applet = new DispApplet();
  disp_frame = new PFrame(disp_applet, 210, 0);
  disp_frame.setTitle("Display");

  tags = new TagLibrary();

  // application.init(proj_width, proj_height);

}

public void draw() {
    //Tag detection and update buffer
    if (cam.available() == true) {
      cam.read();
      tags = ar_detect.detect_tags(cam);
    }

    if (init_on) {
      if (init_count < init_length) {
        init.run();
        init_count++;
      }
      else {
        init_count = 0;
        init_on = false;
      }
    }
    else {
      background(0);
      // application.update(tags);
    }
}


public void keyPressed() {
  if (key == 'i' || key == 'I') {
    init_on = true;
  }
}


// second Processing applet
private class DispApplet extends PApplet {
  public void setup() {
    size(cam_width, cam_height);
    background(255, 0, 0);
    frameRate(30);
  }

  public void draw() {
    disp_buffer.beginDraw();
    disp_buffer.image(cam, 0, 0, cam_width, cam_height);
    disp_buffer.endDraw();

    // tags.drawCam(disp_buffer);

    image(disp_buffer, 0, 0);
  }
}
public interface Application {
	
	public void init(int w, int h);

	public void update(TagLibrary tl);
	
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

  Assembly (int im_width, int im_height) {
    output = new int[10];
    output_count = 0;
    this.im_width = im_width;
    this.im_height = im_height;
    regA = 0;
    regB = 0;
    regC = 0;
    regD = 0;
  }

  public void update(PGraphics pg, int[] regs) {
    pg.beginDraw();
    draw_grid(pg);
    update_reg_vals(pg, regs);
    draw_output(pg);
  }

  public void add_output(int val) {
    if (output_count == output.length) {
      output = expand(output);
    }
    output[output_count++] = val;
  }

  public void draw_grid(PGraphics pg) {
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

  public void update_reg_vals(PGraphics pg, int[] regs) {
    draw_val(regA, regs[0]);
    draw_val(regB, regs[1]);
    draw_val(regC, regs[2]);
    draw_val(regD, regs[3]);
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

  public void draw_output(PGraphics pg) {
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

	public TagLibrary detect_tags(PImage cam_image) {
		TagLibrary tags = new TagLibrary();
		nya.detect(cam_image);

		for (int i = 0; i < num_markers; i++) {
			if ((!nya.isExistMarker(i))) { continue; } //Continue if marker does not exist

			PVector[] pos2d = nya.getMarkerVertex2D(i);

			int num_tags = pos2d.length/4;

			// for (int j = 0; j < num_tags; j++) {
			// 	PVector[] corners = new PVector[4];
			// 	for (int k = 0; k < 4; k++) {
			// 		corners[j].x = pos2d[j + k].x;
			// 		corners[j].y = pos2d[j + k].y;
			// 	}
			// 	Tag tag = new Tag(i, corners);
			// 	tags.addTag(tag);
			// }
		}
		return tags;
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
		String image_prefix = sketchPath("../libraries/nyar4psg/patternMaker/examples/gif/4x4_384_");
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


public class HashMultimap<K, V> {

	private int i = 0;
	private HashMap<K, ArrayList<V>> map = new HashMap<K, ArrayList<V>>();

	public boolean containsKey(Object key) { return map.containsKey(key); }
	public List<V> get(Object key) { return map.get(key); }
	public int size() { return i; }
	
	public void put(K key, V value) {
		ArrayList<V> list = map.get(key);
		
		if (list == null) {
			list = new ArrayList();
			map.put(key, list);
		}
		
		list.add(value);

		i++;
	}

	public Collection<V> values() {
		ArrayList<V> list = new ArrayList<V>();
		
		for (List<V> l : map.values()) {
			for (V v : l) {
				list.add(v);
			}
		}

		return list;
	}
}




/**
 * The Homography class uses a 3x3 matrix to represent the relationship between the
 * points in the camera and the points in the projected image.
 * @author Anis Zaman, Keith O'Hara
 *
 */
public class Homography {

        /**
         * the 3x3 matrix 
         */
        private Matrix H = Matrix.identity(3,3);
        
        /**
         * whether to display debug messages
         */
        public boolean debug = false; 
        
        /**
         * the parent processing sketch
         */
        PApplet parent;

        public Homography() {
        	this(null);
        }

        public Homography(PApplet p){
                parent= p;
        }
        
    /**
     * Load the homography from a file
     * @param filename the homography file
     */
        public void loadFile(String filename){
                String lines[] = parent.loadStrings(filename);
                for (int i=0; i<3; i++){
                        for (int j=0; j<3; j++){
                                H.set(i,j,(Double.parseDouble(lines[i*3+j]))); 
                        }
                }
        }

        /**
         * Estimate the homography between the camera and the projected image using an
         * array of known correspondences. The four corners of the sketch are good for this.
         * 
         * @param cam an array of points in camera coordinates
         * @param proj an array of points in screen coordinates
         */
        public void computeHomography(PVector[] cam, PVector[] proj){
                // Creates an array of two times the size of the cam[] array 
                double[][] a = new double[2*cam.length][];
                
                // Creates the estimation matrix
                for (int i = 0; i < cam.length; i++){
                        double l1 [] = {cam[i].x, cam[i].y, cam[i].z, 0, 0, 0, -cam[i].x*proj[i].x, -cam[i].y*proj[i].x, -proj[i].x};
                        double l2 [] = {0, 0, 0, cam[i].x, cam[i].y, cam[i].z, -cam[i].x*proj[i].y, -cam[i].y*proj[i].y, -proj[i].y};
                        a[2*i] = l1;
                        a[2*i+1] = l2;
                }
                Matrix A = new Matrix(a);
                Matrix T = A.transpose();
                Matrix X = T.times(A);

                EigenvalueDecomposition E = X.eig();
                // Find the eigenvalues and put that in an array
                double[] eigenvalues = E.getRealEigenvalues();
                // grab the first eigenvalue from the eigenvalues []
                double w = eigenvalues[0];
                int r = 0;
                // Find the minimun eigenvalue
                for (int i= 0; i< eigenvalues.length; i++){
                        if (debug) parent.println(eigenvalues[i]);
                        if (eigenvalues[i] <= w){
                                w = eigenvalues[i];
                                r = i;
                        } 
                }
                // find the corresponding eigenvector
                Matrix v = E.getV();

                if (debug) v.print(9,9);
                
                // create the homography matrix from the eigenvector v
                for (int i = 0; i < 3; i++){
                        for (int j = 0; j < 3; j++){
                                H.set(i, j, v.get(i*3+j, r));
                        }
                }
        }
        
        /**
         *  write the homography matrix to a file
         * @param outputFile homography file
         */
        public void writeFile(String outputFile){
                String[] lines = new String[9];
                for (int i = 0; i< 3; i++){
                        for (int j = 0; j< 3; j++){
                                lines[i*3+j] =  Double.toString(H.get(i,j));
                        }
                }
                parent.saveStrings(outputFile, lines);
        }

        /**
         * Find the screen coordinates of the LaserPoint p by
         * multiplying the camera coordinates by the homography matrix.
         * 
         * @param p the 
         */
         /*
        public void computeLaserPosition(LaserPoint p){
                PVector q = new PVector(p.cx, p.cy);
                PVector r = applyHomography(q);
                p.px = p.x;
                p.py = p.y;
                p.x = (int)r.x;
                p.y = (int)r.y;
        }
        */
        
        /**
         * Transform a point p by the homography matrix
         * @param p: PVector to be transformed
         */
        public PVector applyHomography(PVector p){
                double[][] a = new double[3][1];
                a[0][0] = p.x;
                a[1][0] = p.y;
                a[2][0] = 1;
                Matrix D = new Matrix(a);
                Matrix U = H.times(D);
                Matrix L = U.times(1/U.get(2,0));
                PVector p2 = new PVector();
                p2.x = (int)L.get(0, 0);
                p2.y = (int)L.get(1, 0);
                return p2;
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
public class RootApplication implements Application {

	// private static Map<int, Application> applications = new HashMap();

	private int w, h;
	private Application a = new RootApplication();

	public void init(int w, int h) {
		this.w = w;
		this.h = h;

		// applications.put(0, new TOYProgram());
	}

	public void update(TagLibrary tl) {
		Application p = null; /* Choose PROGRAM */
		
		if (p != a) {
			a = p;
			a.init(w, h);
		}

		if (a != null) a.update(tl);
	}
	
}
//Tag ID Values
// 17 MOV
// 18 PRINT
// 19 LABEL
// 20 JNZ
// 21 ADD
// 22 SUB

// 23 RUN
// 24 BINARY
// 25 ASSEMBLY

// 26 0
// 27 1
// 28 2
// 29 3
// 30 4
// 31 5
// 32 6
// 33 7
// 34 8
// 35 9






public class TOYProgram {
    private int[] registers;
    private List<List<Tag>> commands;
    private Hashtable<String, Integer> jumps;
    private boolean isRunning;
    private int eip;
    private float last_time;
    private Assembly assembly;

    private String MapId(int id) {
       if (id == 17)
         return "MOV";
       else if (id == 18)
         return "PRINT";
       else if (id == 19)
         return "LABEL";
       else if (id == 20)
         return "JNZ";
       else if (id == 21)
         return "ADD";
       else if (id == 22)
         return "SUB";
       else if (id == 23)
         return "RUN";
       else if (id == 24)
         return "BINARY";
       else if (id == 25)
         return "ASSEMBLY";
       else {
         Integer ret = id - 26;
         return ret.toString();
       }  
    }
    
    public TOYProgram(int im_width, int im_height) {
      this.registers = new int[4];
      this.isRunning = false;
      this.last_time = System.currentTimeMillis();
      this.eip = 0;
      this.assembly = new Assembly(im_width, im_height);
    }
    
    // called every time in the draw loop
    public void Update(TagLibrary newCommands, PGraphics pg) {
        if (!isRunning) {
           commands = newCommands.getTagRows();
           eip = 0;
        }
        else {
           // see if execute another step
           if (last_time - System.currentTimeMillis() > 1000.0f) {
              last_time = System.currentTimeMillis();
              Step();
                           
              // update Assembly
              assembly.update(pg, registers);
           } 
           return;
        }       
    }
    
    private boolean isInteger(String arg) {
      try {
        int i = Integer.parseInt(arg);
      }
      catch (NumberFormatException e) {
        return false;
      }
      return true;
    }
    
    private void movCommand(String arg1, String arg2) {
      int movNumber = 0;
      if (isInteger(arg1)) {
        movNumber = Integer.parseInt(arg1);
      } else if (arg1.equals("A")) {
        movNumber = registers[0];
      } else if (arg1.equals("B")) {
        movNumber = registers[1];
      } else if (arg1.equals("C")) {
        movNumber = registers[2];
      } else if (arg1.equals("D")) {
        movNumber = registers[3];
      } else {
        System.err.println("Error with second tag on line: " + eip);
      }
      if (arg2.equals("A")) {
        registers[0] = movNumber;
      } else if (arg2.equals("B")) {
        registers[1] = movNumber;
      } else if (arg2.equals("C")) {
        registers[2] = movNumber;
      } else if (arg2.equals("D")) {
        registers[3] = movNumber;
      } else {
        System.err.println("Error with third tag on line: " + eip);
      }
      eip++;
    }
    
    private void printCommand(String arg1) {
      if (arg1.equals("A")) {
        System.out.println("A: " + registers[0]);
      } else if (arg1.equals("B")) {
        System.out.println("B: " + registers[1]);
      } else if (arg1.equals("C")) {
        System.out.println("C: " + registers[2]);
      } else if (arg1.equals("D")) {
        System.out.println("D: " + registers[3]);
      } else {
        System.err.println("Error with second tag on line: " + eip);
      }
      eip++;
    }
    
    private void addCommand(String arg1, String arg2) {
      int addNumber = 0;
      if (isInteger(arg1)) {
        addNumber = Integer.parseInt(arg1);
      } else if (arg1.equals("A")) {
        addNumber = registers[0];
      } else if (arg1.equals("B")) {
        addNumber = registers[1];
      } else if (arg1.equals("C")) {
        addNumber = registers[2];
      } else if (arg1.equals("D")) {
        addNumber = registers[3];
      } else {
        System.err.println("Error with second tag on line: " + eip);
      }
      if (arg2.equals("A")) {
        registers[0] += addNumber;
      } else if (arg2.equals("B")) {
        registers[1] += addNumber;
      } else if (arg2.equals("C")) {
        registers[2] += addNumber;
      } else if (arg2.equals("D")) {
        registers[3] += addNumber;
      } else {
        System.err.println("Error with third tag on line: " + eip);
      }
      eip++;
    }
    
    private void subCommand(String arg1, String arg2) {
      int subNumber = 0;
      if (isInteger(arg1)) {
        subNumber = Integer.parseInt(arg1);
      } else if (arg1.equals("A")) {
        subNumber = registers[0];
      } else if (arg1.equals("B")) {
        subNumber = registers[1];
      } else if (arg1.equals("C")) {
        subNumber = registers[2];
      } else if (arg1.equals("D")) {
        subNumber = registers[3];
      } else {
        System.err.println("Error with second tag on line: " + eip);
      }
      if (arg2.equals("A")) {
        registers[0] -= subNumber;
      } else if (arg2.equals("B")) {
        registers[1] -= subNumber;
      } else if (arg2.equals("C")) {
        registers[2] -= subNumber;
      } else if (arg2.equals("D")) {
        registers[3] -= subNumber;
      } else {
        System.err.println("Error with third tag on line: " + eip);
      }
      eip++;
    }
    
    private void jnzCommand(String arg1, String arg2) {
      int registerValue = 0;
      if (arg1.equals("A"))
        registerValue = registers[0];
      else if (arg1.equals("B"))
        registerValue = registers[1];
      else if (arg1.equals("C"))
        registerValue = registers[2];
      else if (arg1.equals("D"))
        registerValue = registers[3];
      else 
        System.err.println("Error with  second tag on line: " + eip);
      if (registerValue != 0) {
        Integer new_eip = jumps.get(arg2);
        if (new_eip == null) {
          System.err.println("Label not recognized");
        }
        eip = new_eip + 1;
      }
      else {
        eip++;
      }
    }
    
    private void labelCommand(String arg1) {
      jumps.put(arg1, eip);
      eip++;
    }
    
    public void Step() {
      List<Tag> line = commands.get(eip);
      String command = MapId(line.get(0).id);
      if (command.equals("MOV")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          movCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("PRINT")) {
        if (line.size() != 2)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          printCommand(MapId(line.get(1).id));
      }
      else if (command.equals("ADD")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          addCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("SUB")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          subCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("JNZ")) {
        if (line.size() != 3)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          jnzCommand(MapId(line.get(1).id), MapId(line.get(2).id));
      }
      else if (command.equals("LABEL")) {
        if (line.size() != 2)
          System.err.println("Error with number of arguments on line: " + eip);
        else
          labelCommand(MapId(line.get(1).id));
      }
      else {
        System.err.println("Command not found: " + command);
      }
    }
}


public static int NUM_CORNERS = 4;

public class Tag {
	private int id;
	private PVector[] cam_corners;
	private PVector cam_center;
	private PVector[] projector_corners;
	private PVector projector_center;

	Tag(int id, PVector[] cam_corners) {
		assert(cam_corners.length == NUM_CORNERS);

		this.id = id;
		this.cam_corners = cam_corners;
		this.cam_center = getCenter(cam_corners);
	}

	private PVector getCenter(PVector[] corners) {
		PVector center = new PVector(corners[0].x + (corners[3].x - corners[0].x)/2, corners[0].y + (corners[3].y - corners[0].y)/2);
		return center;
	}

	public int getId() { return id; }
	public PVector[] getCamCorners() { return cam_corners; }
	public PVector getCamCenter() { return cam_center; }
	public PVector[] getProjectorCorners() { return projector_corners; }
	public PVector getProjectorCenter() { return projector_center; }

	public void applyHomography(Homography h) {
		for (int i = 0; i < NUM_CORNERS; i++) {
			projector_corners[i] = h.applyHomography(cam_corners[i]);
		}

		projector_center = getCenter(projector_corners);
	}

	public void drawCam(PGraphics pg) {
		drawCorners(pg, cam_corners);
	}

	public void drawProjector(PGraphics pg) {
		drawCorners(pg, projector_corners);
	}

	public void drawCorners(PGraphics pg, PVector[] c) {
		fill(0, 255, 0);
		for (int i = 0; i < NUM_CORNERS; i++) {
			String s = i + " : (" + PApplet.parseInt(c[i].x) + "," + PApplet.parseInt(c[i].y) + ")";
			pg.fill(0);
			pg.text(s, c[i].x + 2, c[i].y + 2);
			pg.fill(255, 0, 0);
			pg.ellipse(c[i].x, c[i].y, 5, 5);
		}
	}
}

//Tag ID Values
// 17 MOV
// 18 PRINT
// 19 LABEL
// 20 JNZ
// 21 ADD
// 22 SUB

// 23 RUN
// 24 BINARY
// 25 ASSEMBLY

// 26 0
// 27 1
// 28 2
// 29 3
// 30 4
// 31 5
// 32 6
// 33 7
// 34 8
// 35 9


public class TagLibrary {

	ArrayList<Tag> tag_list = new ArrayList<Tag>();
	// HashMap<int, Tag> tag_map = new HashMap<int, Tag>();

	public void addTag(Tag tag) {
		tag_list.add(tag);
	}

	public int numTags() {
		return tag_list.size();
	}

	public List<Tag> getTags() {
		return tag_list;
	}

	public List<List<Tag>> getTagRows() {
		return null;
	}

	public void drawProjector(PGraphics pg) {
		for (Tag tag : tag_list) {
			tag.drawProjector(pg);
		}
	}

	public void drawCam(PGraphics pg) {
		for (Tag tag : tag_list) {
			tag.drawCam(pg);
		}
	}
}


public class TagRow {

	private ArrayList<Tag> tags = new ArrayList<Tag>();

	/*
	private class TagComparator implements Comparator {
		
	}
	*/

	public void addTag(Tag tag) {
		tags.add(tag);
		// Collections.sort(tags);
	}
}

 // the NyARToolkit Processing library

class Translate {
	private Homography h = new Homography();

	public void translate_init(TagLibrary tl) {
		PVector[] cam = new PVector[tl.numTags() * 4];
		PVector[] proj = new PVector[tl.numTags() * 4];

		int i = 0;
		for (Tag tag : tl.getTags()) {
			for (int j = 0; j < NUM_CORNERS; j++) {
				cam[i] = tag.getCamCorners()[j];
				proj[i] = tag.getProjectorCorners()[j];
				i++;
			}
		}

		h.computeHomography(cam, proj);
	}

	public void translate_run(TagLibrary tl) {
		for (Tag tag : tl.getTags()) {
			tag.applyHomography(h);
		}
	}

	public void translate_debug(TagLibrary tl, PGraphics pg) {
		tl.drawCam(pg);
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
