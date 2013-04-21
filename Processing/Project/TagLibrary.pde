import java.util.*;

public class TagLibrary {

	ArrayList<Tag> tag_list = new ArrayList<Tag>();
	HashMultimap<Integer, Tag> tag_map = new HashMultimap<Integer, Tag>();
	ArrayList<TagRow> tag_rows = new ArrayList<TagRow>();

	public void addTag(Tag tag) {
		tag_list.add(tag);
		
		tag_map.put(tag.getId(), tag);
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
		tag_rows.clear();

		for (Tag tag : tag_list) {
			// Add tag to existing tag row if possible.
			for (TagRow row : tag_rows) {
				if (row.doesContain(tag)) {
					row.add(tag);
					return tag_rows;
				}
			}

			TagRow row = new TagRow();
			row.add(tag);
			tag_rows.add(row);
		}

		Collections.sort(tag_rows);
		return tag_rows;
	}

	public void drawProj(PGraphics pg) {
		for (Tag tag : tag_list) {
			tag.drawProj(pg);
		}
	}

	public void drawCam(PGraphics pg) {
		for (Tag tag : tag_list) {
			tag.drawCam(pg);
		}
	}

	public void debug() {
		for (Tag tag : tag_list) {
			tag.debug();
		}
	}

	public void clear() {
		tag_list.clear();
		tag_map.clear();
		tag_rows.clear();
	}
}
