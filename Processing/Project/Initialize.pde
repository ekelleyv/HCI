class Initialize {
	private Grid init_grid = new Grid(1, 1, 300);

	public void generate_display(PGraphics pg) {		
		init_grid.generate_display(pg);
	}

	private void addProjectorCorners(Tag tag) {
		tag.setProjectorCorners(init_grid.getTagCorners(tag.getId()));
	}

	public void addProjectorCorners(TagLibrary tl) {
		/*
		if (tl.getTags(0) != null) {
			if (tl.getTags(0).size() > 0) {
				addProjectorCorners(tl.getTags(0).get(0));
			}
		}
		*/

		for (Tag tag : tl.getTags()) {
			addProjectorCorners(tag);
		}
	}
}