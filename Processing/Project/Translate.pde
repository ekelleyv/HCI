import processing.video.*;
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library

class Translate {
	Homography h = new Homography();

	static void translate_init(TagLibrary tl) {
		PVector[] cam = new PVector[tl.numTags() * 4];
		PVector[] proj = new PVector[tl.numTags() * 4];

		int i = 0;
		for (Tag tag : tl.getTags()) {
			for (int j = 0; j < Tag.NUM_CORNERS; j++) {
				cam[i] = tag.camCorners()[j];
				proj[i] = tag.projCorners()[j];
				i++;
			}
		}

		h.computeHomography(cam, proj);
	}

	static void translate_run(TagLibrary tl) {
		for (Tag tag : tl.getTags()) {
			tag.applyHomography(h);
		}
	}

	static void translate_debug(TagLibrary tl, PGraphics pg) {
		tl.draw(pg);
	}
}