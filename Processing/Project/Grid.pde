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

	void setup() {
		String image_prefix = "/Users/ekelley/Google Drive/Projects/HCI/Processing/libraries/nyar4psg/patternMaker/examples/gif/4x4_384_";
		//Load images
		int num_images = row*col;

		for (int i = 1; i < (num_images+1); i++) {
			ar_images.add(loadImage(image_prefix + i + ".gif"));
		}
	}

	void generate_display(PGraphics pg) {
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