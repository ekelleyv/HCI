class Initialize {
	private Grid init_grid = new Grid(1, 1, 300);
	private int init_tag = 141;

	public void generate_display(PGraphics pg) {		
		init_grid.generate_display(pg, init_tag);
	}

	private void addProjectorCorners(Tag tag) {
		tag.setProjectorCorners(init_grid.getTagCorners());
	}

	public int getInitTag() { return init_tag; }

	public void addProjectorCorners(TagLibrary tl) {
		if (tl.getTags(init_tag) == null || tl.getTags(0).size() == 0) return;
		addProjectorCorners(tl.getTags(init_tag).get(0));

		/*
		for (Tag tag : tl.getTags()) {
			addProjectorCorners(tag);
		}
		*/
	}
}