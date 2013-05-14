class Initialize {
	// private Grid init_grid = new Grid(1, 1, 300);
	private final int INIT_TAG_ID = 140;
	private int marker_width;
	private PImage init_image;

	public Initialize() {
		init_image = loadImage(sketchPath("../libraries/nyar4psg/patternMaker/examples/gif/4x4_384_141.gif"));
		if (init_image == null) System.out.println("Init image failed to load.");

		marker_width = min(height, width) / 2;
	}

	public void generate_display(PGraphics pg) {
		pg.background(255);
		PVector[] corners = getTagCorners();
		pg.image(init_image, corners[0].x, corners[0].y, marker_width, marker_width);
	}

	public void addProjectorCorners(TagLibrary tl) {
		List<Tag> init_tags = tl.getTags(INIT_TAG_ID);

		if (init_tags == null || init_tags.size() < 1) return;

		// Uncomment for println debuggings
		/*
		if (init_tags == null || init_tags.size() < 1) {
			System.out.println("Init tag not found");
			return;
		}
		*/

		init_tags.get(0).setProjectorCorners(getTagCorners());
	}

	private PVector[] getTagCorners() {
		int x_mid = width / 2;
		int y_mid = height / 2;

		PVector[] corners = new PVector[4];

		corners[0] = new PVector(x_mid - marker_width / 2, y_mid - marker_width / 2);
		corners[1] = new PVector(corners[0].x + marker_width, corners[0].y);
		corners[2] = new PVector(corners[0].x + marker_width, corners[0].y + marker_width);
		corners[3] = new PVector(corners[0].x, corners[0].y + marker_width);

		return corners;
	}
}