import java.util.*;

public class TagLibrary {

	ArrayList<Tag> tag_list = new ArrayList<Tag>();
	HashMultimap<Integer, Tag> tag_map = new HashMultimap<Integer, Tag>();
	ArrayList<TagRow> tag_rows = new ArrayList<TagRow>();

	public void addTag(Tag tag) {
		tag_list.add(tag);
		tag_map.put(tag.getId(), tag);

		for (TagRow row : tag_rows) {
			if (row.doesContain(tag)) {
				row.add(tag);
				return;
			}
		}

		TagRow row = new TagRow();
		row.add(tag);
		tag_rows.add(row);
	}

	public int numTags() {
		return tag_list.size();
	}

	public List<Tag> getTags(int id) {
		return tag_map.get(id);
	}

	public List<Tag> getTags() {
		return tag_list;
	}

	public List<TagRow> getTagRows() {
		return tag_rows;
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
