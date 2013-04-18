public class RootApplication implements Application {

	// private static Map<int, Application> applications = new HashMap();

	private int w, h;
	private Application a = new RootApplication();

	public void init(int w, int h) {
		this.w = w;
		this.h = h;

		// applications.put(0, new TOYProgram());
	}

	public void update(TagLibrary tl) {
		Application p = null; /* Choose PROGRAM */
		
		if (p != a) {
			a = p;
			a.init(w, h);
		}

		if (a != null) a.update(tl);
	}
	
}
