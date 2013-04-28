public class RootApplication implements Application {

	private Map<Integer, Application> applications = new HashMap<Integer, Application>();

	private int w, h;

	public void init(int w, int h) {
		this.w = w;
		this.h = h;

		applications.put(133, new TOYProgram());
		applications.put(134, new Binary());

		for (Application a : applications.values()) {
			a.init(w, h);
		}
	}

	public void update(TagLibrary tl, PGraphics pg) {
		Application a = null;

		for (int id : applications.keySet()) {
			if (tl.containsTag(id)) {
				if (a != null) {
					System.out.println("Multiple application tags detected.");
					return;
				} else {
					a = applications.get(id);
				}
			}
		}

		if (a == null) {
			// System.out.println("No application tag detected.");
			return;
		}

		a.update(tl, pg);
		/*
		try {
			a.update(tl, pg);
		} catch(Exception e) {
			System.out.println("Application threw and Exception.");
			e.printStackTrace();
		}
		*/
	}
	
}
