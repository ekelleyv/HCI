import processing.video.*;
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library

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
		tl.draw(pg);
	}
}