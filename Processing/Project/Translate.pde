import processing.video.*;
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library

class Translate {
	private Homography h = new Homography();
	private final int INIT_TAG_ID = 140;

	public void init(TagLibrary tl) {
		List<Tag> init_tags = tl.getTags(INIT_TAG_ID);

		if (init_tags == null || init_tags.size() < 1) {
			System.out.println("Translate: Initialization tag not found.");
			return;
		}

		Tag tag = init_tags.get(0);

		this.h = new Homography();
		
		PVector[] cam = new PVector[NUM_CORNERS];
		PVector[] proj = new PVector[NUM_CORNERS];

		for (int i = 0; i < NUM_CORNERS; i++) {
			cam[i] = tag.getCamCorners()[i];
			proj[i] = tag.getProjectorCorners()[i];
		}

		// Uncomment for println debugging
		/*
		println();
		for (int j = 0; j < cam.length; j++) println(cam[j] + " = " + proj[j]);
		println();
		*/

		h.computeHomography(cam, proj);
	}

	public void run(TagLibrary tl) {
		for (Tag tag : tl.getTags()) {
			tag.applyHomography(h);
		}
	}

	public void debug(TagLibrary tl, PGraphics pg) {
		tl.drawProj(pg);
	}
}