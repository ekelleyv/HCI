//Tag ID Values
// 17 MOV
// 18 PRINT
// 19 LABEL
// 20 JNZ
// 21 ADD
// 22 SUB

// 23 RUN
// 24 BINARY
// 25 ASSEMBLY

// 26 0
// 27 1
// 28 2
// 29 3
// 30 4
// 31 5
// 32 6
// 33 7
// 34 8
// 35 9

import java.util.*;

public enum TagType {
	NONE,
	BINARY,
	LITERAL,
	INSTRUCTION,
	META
}

class Tag {
	int id;
	TagType type;
	String val;

	Tag(int id, double x_center_cam, double y_center_cam) {
		this.id = id;
		this.type = get_type();
		this.val = get_val();
	}

	get_val() {
		val = "";
	}

	get_type() {
		type = NONE;
		if (id <=16) {
			type = BINARY;
		}
		else if (id <= 22) {
			type = INSTRUCTION;
		}
		else if (id <= 25) {
			type = META;
		}
		else if (id <= 35) {
			type = LITERAL;
		}
	}
}