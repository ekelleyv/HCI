import processing.video.*;
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library

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

	void setup() {
		//Set delay for determining tag "lost"
		nya.setLostDelay(1);
		String[] patterns = loadPatternFilenames(pattern_filepath);

		for (int i=0; i<num_markers; i++) {
			nya.addARMarker(patternPath + "/" + patterns[i], 80);
		}
	}

	TagLibrary detect_tags(PImage cam_image) {
		assert(cam_image != null);

		TagLibrary tags = new TagLibrary();
		try {
			nya.detect(cam_image);
		} catch (Exception e) {
			System.out.println("We caught the exception.  Yay!");
		}

		for (int i = 0; i < num_markers; i++) {
			if (!nya.isExistMarker(i)) { continue; } // Continue if marker does not exist

			PVector[] pos2d = nya.getMarkerVertex2D(i);

			int num_tags = pos2d.length / NUM_CORNERS;

			for (int j = 0; j < num_tags; j++) {
				PVector[] corners = new PVector[4];
				for (int k = 0; k < NUM_CORNERS; k++) {
					corners[k] = pos2d[j * NUM_CORNERS + k];
					assert(corners[j] != null);
				}
				tags.addTag(new Tag(i, corners));
			}
		}
		return tags;
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