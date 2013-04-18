import java.util.*;

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

	void applyHomography(Homography h) {
		for (int i = 0; i < NUM_CORNERS; i++) {
			projector_corners[i] = h.applyHomography(cam_corners[i]);
		}

		projector_center = getCenter(projector_corners);
	}

	void drawProjector(PGraphics pg) {
		PVector[] c = projector_corners;

		fill(0, 255, 0);
		for (int i = 0; i < NUM_CORNERS; i++) {
			String s = i + " : (" + int(c[i].x) + "," + int(c[i].y) + ")";
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
