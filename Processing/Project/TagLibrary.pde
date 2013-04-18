import java.util.*;

public class TagLibrary {

	ArrayList<Tag> tag_list = new ArrayList<Tag>();
	// HashMap<int, Tag> tag_map = new HashMap<int, Tag>();

	public void addTag(Tag tag) {
		tag_list.add(tag);
	}

	public int numTags() {
		return tag_list.size();
	}

	public List<Tag> getTags() {
		return tag_list;
	}

	public List<List<Tag>> getTagRows() {
		return null;
	}

	public void drawProjector(PGraphics pg) {
		for (Tag tag : tag_list) {
			tag.drawProjector(pg);
		}
	}

	public void drawCam(PGraphics pg) {
		for (Tag tag : tag_list) {
			tag.drawCam(pg);
		}
	}
}
