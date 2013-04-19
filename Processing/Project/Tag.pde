import java.util.*;

public static int NUM_CORNERS = 4;

public class Tag {
	private int id;

	private PVector[] cam_corners;
	private PVector cam_center;

	private PVector[] projector_corners;
	private PVector projector_center;

	private double maxX = Double.NEGATIVE_INFINITY;
	private double maxY = Double.NEGATIVE_INFINITY;
	private double minX = Double.POSITIVE_INFINITY;
	private double minY = Double.POSITIVE_INFINITY;

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

	public double getMaxX() { return maxX; }
	public double getMaxY() { return maxY; }
	public double getMinX() { return minX; }
	public double getMinY() { return minY; }

	void applyHomography(Homography h) {
		maxX = maxY = Double.POSITIVE_INFINITY;
		minX = minY = Double.NEGATIVE_INFINITY;

		for (int i = 0; i < NUM_CORNERS; i++) {
			PVector v = h.applyHomography(cam_corners[i]);
			
			if (v.x > maxX) maxX = v.x;
			if (v.y > maxY) maxY = v.y;
			if (v.x < minX) minX = v.x;
			if (v.y < minY) minY = v.y;

			projector_corners[i] = v;
		}

		projector_center = getCenter(projector_corners);
	}

	void drawCam(PGraphics pg) {
		drawCorners(pg, cam_corners);
	}

	void drawProjector(PGraphics pg) {
		drawCorners(pg, projector_corners);
	}

	void drawCorners(PGraphics pg, PVector[] c) {
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
