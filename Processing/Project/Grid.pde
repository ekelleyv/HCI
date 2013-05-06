class Grid {
	private int row;
	private int col;
	private int marker_width;
	
	private ArrayList<PImage> ar_images;

	public Grid(int row, int col, int marker_width) {
		this.row = row;
		this.col = col;
		this.marker_width = marker_width;
		
		this.ar_images = new ArrayList<PImage>();

		//Load images
		String image_prefix = sketchPath("../libraries/nyar4psg/patternMaker/examples/gif/4x4_384_");
		int num_images = row * col;
		for (int i = 1; i < (num_images+1); i++) {
			ar_images.add(loadImage(image_prefix + i + ".gif"));
		}
	}

	public void generate_display(PGraphics pg) {
		pg.background(255);

		for (int id = 0; id < ar_images.size(); id++) {
			PVector[] corners = getTagCorners(id);
			pg.image(ar_images.get(id), corners[0].x, corners[0].y, marker_width, marker_width);
		}

		/*
		for (int i = 0; i < row; i++) {
			for (int j = 0; j < col; j++) {
				PVector[] corners = getTagCorners(i, j);
				image(ar_images.get((i*col) + j), corners[0].x, corners[0].y, marker_width, marker_width);
			}
		}
		*/
	}

	public PVector[] getTagCorners(int id) {
		return getTagCorners(id / col, id % col);
	}

	private PVector[] getTagCorners(int i, int j) {
		int x_space = (int) width / (col + 1);
		int y_space = (int) height / (row + 1);

		PVector[] corners = new PVector[4];

		// TODO: THIS MIGHT NOT BE THE RIGHT ORDER
		corners[0] = new PVector((j + 1) * x_space - marker_width/2, (i + 1) * y_space - marker_width/2);
		corners[1] = new PVector(corners[0].x + marker_width, corners[0].y);
		corners[2] = new PVector(corners[0].x + marker_width, corners[0].y + marker_width);
		corners[3] = new PVector(corners[0].x, corners[0].y + marker_width);

		return corners;
	}
}