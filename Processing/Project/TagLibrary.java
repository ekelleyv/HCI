import processing.video.*;
import jp.nyatla.nyar4psg.*; // the NyARToolkit Processing library
import java.util.ArrayList;

public class TagLibrary {

	ArrayList<Tag> tags = new ArrayList<Tag>();

	public void addTag(Tag tag) {
		tags.add(tag);
	}

	public List<Tag> getTags() {
		return tags;
	}

	public List<List<Tag>> getTagRows() {
		
	}
}