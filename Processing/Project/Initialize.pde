class Initialize {
	Grid init_grid;

	Initialize() {
		init_grid = new Grid(5, 5, 80);
	}

	void run() {
		int start = millis();
		int init_length = 10000;
		init_grid.display();

		// while (millis() < (start + init_length)) {
		// 	delay(10);
		// }
	}
}