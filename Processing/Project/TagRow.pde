import java.util.*;

public class TagRow {

	private ArrayList<Tag> tags = new ArrayList<Tag>();

	/*
	private class TagComparator implements Comparator {
		
	}
	*/

	public void addTag(Tag tag) {
		tags.add(tag);
		// Collections.sort(tags);
	}
}
