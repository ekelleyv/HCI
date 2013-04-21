class Initialize {
	private Grid init_grid = new Grid(1, 1, 500);

	public void generate_display(PGraphics pg) {		
		init_grid.generate_display(pg);
	}

	private void addProjectorCorners(Tag tag) {
		tag.setProjectorCorners(init_grid.getTagCorners(tag.getId()));
	}

	public void addProjectorCorners(TagLibrary tl) {
		for (Tag tag : tl.getTags()) {
			addProjectorCorners(tag);
		}
	}
}