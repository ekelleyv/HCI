import java.util.*;

public static int NUM_CORNERS = 4;

public class Tag implements Comparable<Tag> {
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
		assert(cam_corners != null);
		assert(cam_corners.length == NUM_CORNERS);

		this.id = id;
		this.cam_corners = cam_corners;
		this.cam_center = getCenter(cam_corners);

		for (int i = 0; i < NUM_CORNERS; i++) {
			cam_corners[i].z = 1.0;
		}
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

	public void setProjectorCorners(PVector[] corners) {
		assert(corners != null);
		assert(corners.length == NUM_CORNERS);

		for (int i = 0; i < NUM_CORNERS; i++) {
			corners[i].z = 1.0;
		}

		projector_corners = corners;

		maxX = maxY = Double.POSITIVE_INFINITY;
		minX = minY = Double.NEGATIVE_INFINITY;

		for (int i = 0; i < NUM_CORNERS; i++) {
			PVector v = projector_corners[i];

			if (v.x > maxX) maxX = v.x;
			if (v.y > maxY) maxY = v.y;
			if (v.x < minX) minX = v.x;
			if (v.y < minY) minY = v.y;
		}

		projector_center = getCenter(projector_corners);
	}

	public void applyHomography(Homography h) {
		PVector[] corners = new PVector[4];

		for (int i = 0; i < NUM_CORNERS; i++) {
			corners[i] = h.applyHomography(cam_corners[i]);
		}

		setProjectorCorners(corners);

		/*
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
		*/
	}

	public void drawCam(PGraphics pg) {
		drawCorners(pg, cam_corners);
	}

	public void drawProj(PGraphics pg) {
		drawCorners(pg, projector_corners);
	}

	public void debug() {
		print("Tag - " + id + " ");
		for (int i = 0; i < NUM_CORNERS; i++) print(" [ " + cam_corners[i].x + ", " + cam_corners[i].y + ", " + cam_corners[i].z + " ] ");
		print(" ");
		for (int i = 0; i < NUM_CORNERS; i++) print(" [ " + projector_corners[i].x + ", " + projector_corners[i].y + ", " + projector_corners[i].z + " ] ");
		println();
	}

	public void drawCorners(PGraphics pg, PVector[] c) {
		if (c == null) return;

		pg.fill(0, 255, 0);
		for (int i = 0; i < NUM_CORNERS; i++) {
			String s = i + " : (" + int(c[i].x) + "," + int(c[i].y) + ")";
			pg.fill(0);
			pg.text(s, c[i].x + 2, c[i].y + 2);
			pg.fill(255, 0, 0);
			pg.ellipse(c[i].x, c[i].y, 5, 5);
		}

		pg.fill(255);
		pg.textSize(32);
		pg.text(id, c[0].x + 50, c[0].y);
	}

	public int compareTo(Tag that) {
		if (this.maxX == that.maxX) return 0;
		else if (this.maxX > that.maxX) return 1;
		else return -1;
	}

	public String toString() {
		String s = "Tag:{";

		s += "id=" + id;
		//s += ", cam_corners=" + cam_corners;
		//s += ", cam_center=" + cam_center;
		//s += ", projector_corners=" + projector_corners;
		//s += ", projector_center=" + projector_center;

		return s + "}\n";
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
