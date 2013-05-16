public class Poster implements Application {
	private int w, h;
	private PImage poster;

	public void init(int w, int h) {
		this.w = w;
		this.h = h;
		poster = loadImage("Poster.png");
	}

	public void update(TagLibrary tl, PGraphics pg) {
		pg.background(0);
		pg.image(poster, 0, 0, w, h);
	}
}