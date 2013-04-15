import processing.video.*;
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library
import java.util.ArrayList;

public class TagLibrary {

	ArrayList<Tag> tags = new ArrayList<Tag>();

	public void addTag(Tag tag) {
		tags.add(tag);
	}

	public int numTags() {
		return tags.size();
	}

	public List<Tag> getTags() {
		return tags;
	}

	public List<List<Tag>> getTagRows() {
		
	}

	public void draw(PGraphics pg) {
		for (Tag tag : tags) {
			tag.drawProjector(pg);
		}
	}
}