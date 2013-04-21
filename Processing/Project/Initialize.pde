class Initialize {
	private Grid init_grid;

	public Initialize() {
		init_grid = new Grid(5, 5, 80);
	}

	public void generate_display() {		
		init_grid.generate_display();
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