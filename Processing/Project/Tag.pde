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

import java.util.*;

class Tag {

	public static int NUM_CORNERS = 4;

	private int id;
	private PVector[] cam_corners;
	private PVector cam_center;
	private PVector[] projector_corners;
	private PVector projector_center;

	Tag(int id, PVector[] cam_corners) {
		assert(len(cam_corners) == NUM_CORNERS);

		this.id = id;
		this.cam_corners = cam_corners;
		this.cam_center = getCenter(cam_corners);
	}

	private getCenter(PVector[] corners) {
		PVector center = new PVector(corners[0].x + (corners[3].x - corners[0].x)/2, corners[0].y + (corners[3].y - corners[0].y)/2);
		return center;
	}

	getId() {
		return id;
	}

	getCamCorners() {
		return cam_corners;
	}

	getCamCenter() {
		return cam_center;
	}

	getProjectorCorners() {
		return cam_corners;
	}

	getProjectorCenter() {
		return cam_center;
	}

	void applyHomography(Homography h) {
		for (int i = 0; i < NUM_CORNERS; i++) {
			projector_corners[i] = h.applyHomography(cam_corners[i]);
		}
	}

	void drawProjector(PGraphics pg) {
		tag.getProjectorCorners();

		PVector[] c = projector_corners;

		fill(0, 255, 0);
		for (int i = 0; i < NUM_CORNERS; i++) {
				String s = j + " : (" + int(c[j].x) + "," + int(c[j].y) + ")";
				pg.fill(0);
				pg.text(s, c[j].x + 2, c[j].y + 2);
				pg.fill(255, 0, 0);
				pg.ellipse(c[j].x, c[j].y, 5, 5);
			}
		}
	}
}