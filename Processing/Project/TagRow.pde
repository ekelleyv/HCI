import java.util.*;

public class TagRow implements Iterable<Tag>, Comparable<TagRow> {

	private ArrayList<Tag> tags = new ArrayList<Tag>();

	private double maxX = Double.NEGATIVE_INFINITY;
	private double maxY = Double.NEGATIVE_INFINITY;
	private double minX = Double.POSITIVE_INFINITY;
	private double minY = Double.POSITIVE_INFINITY;

	public double getMaxX() { return maxX; }
	public double getMaxY() { return maxY; }
	public double getMinX() { return minX; }
	public double getMinY() { return minY; }

	public Tag get(int i) { return tags.get(i); }
	public int size() { return tags.size(); }

	public double Width() { maxY - minY; }
	public double Height() { maxX - minX; }

	public void clear() {
		tags.clear();

		maxX = maxY = Double.NEGATIVE_INFINITY;
		minX = minY = Double.POSITIVE_INFINITY;
	}

	public void add(Tag tag) {
		tags.add(tag);

		if (tag.getMaxX() > maxX) maxX = tag.getMaxX();
		if (tag.getMinX() < minX) minX = tag.getMinX();
		if (tag.getMaxY() > maxY) maxY = tag.getMaxY();
		if (tag.getMinY() < minY) minY = tag.getMinY();

		Collections.sort(tags);
	}

	public boolean doesContain(Tag tag) {
		PVector c = tag.getProjectorCenter();
		
		if (c.x > maxX) return false;
		if (c.x < minX) return false;
		if (c.y > maxY) return false;
		if (c.y < minY) return false;

		return true;
	}

	public Iterator<Tag> iterator() { return tags.iterator(); }

	public int compareTo(TagRow that) {
		if (this.maxY == that.maxY) return 0;
		else if (this.maxY > that.maxY) return 1;
		else return -1;
	}

	public void drawProj(PGraphics pg) {
		pg.stroke(255);
		pg.fill(0);
		pg.rect(minX - 0.1 * Width, minY - 0.1 * Height(), 1.2 * Width(), 1.2 * Height());
	}

	public String toString() {
		String s = "TagRow:{ tags=";
		s += tags;

		s += ", maxX=" + maxX;
		s += ", minX=" + minX;
		s += ", maxY=" + maxY;
		s += ", minY=" + minY;

		return s + "}\n";
	}
}
