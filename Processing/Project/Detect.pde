import processing.video.*;
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library

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

	void setup() {
		//Set delay for determining tag "lost"
		nya.setLostDelay(1);
		String[] patterns = loadPatternFilenames(pattern_filepath);

		for (int i=0; i<num_markers; i++) {
			nya.addARMarker(patternPath + "/" + patterns[i], 80);
		}
	}

	void run (PImage cam_image) {

		nya.detect(cam_image);
	}

	void draw_markers() {
		for (int i = 0; i < num_markers; i++) {
			if ((!nya.isExistMarker(i))) { continue; } //Continue if marker does not exist

			PVector[] pos2d = nya.getMarkerVertex2D(i);
			// draw each vector both textually and with a red dot
			for (int j=0; j<pos2d.length; j++) {
				String s = j + " : (" + int(pos2d[j].x) + "," + int(pos2d[j].y) + ")";
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
	String[] loadPatternFilenames(String path) {
		File folder = new File(path);
		FilenameFilter pattFilter = new FilenameFilter() {
			public boolean accept(File dir, String name) {
				return name.toLowerCase().endsWith(".patt");
			}
		};
		return folder.list(pattFilter);
	}
}