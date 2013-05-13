public class RootApplication implements Application {

	private Map<Integer, Application> applications = new HashMap<Integer, Application>();
	private Application a = null;
	private int w, h;

	public void init(int w, int h) {
		this.w = w;
		this.h = h;

		applications.put(133, new TOYProgram());
		applications.put(138, new Binary());

		for (Application a : applications.values()) {
			a.init(w, h);
		}
	}

	public void update(TagLibrary tl, PGraphics pg) {
		Application new_application = null;

		for (int id : applications.keySet()) {
			if (tl.containsTag(id)) {
				if (new_application != null) {
					System.out.println("Multiple application tags detected.");
					a = null;
					return;
				} else {
					new_application = applications.get(id);
				}
			}
		}

		if (new_application != null) {
			a = new_application;
		}

		if (a == null) return;

		// a.update(tl, pg);
		try {
			a.update(tl, pg);
		} catch(Exception e) {
			System.out.println("Application threw an Exception.");
			e.printStackTrace();
		}
	}
	
}
