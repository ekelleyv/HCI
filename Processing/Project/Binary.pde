import java.util.*;

public class Binary implements Application {

	private HashMap<Integer, String> numbers = new HashMap<Integer, String>();
	private HashMap<Integer, Integer> bases = new HashMap<Integer, Integer>();

  private float x = 0;
  private float y = 0;

  public void init(int im_width, int im_height) {
  	// Add the numbers to the library
  	for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 6; j++) {
        numbers.put(i * 6 + j, Integer.toString(i, 16).toUpperCase());
      }
    }


    // Add the bases to the library
    bases.put(134, 2);   // Binary
  	bases.put(135, 8);   // Octal
  	bases.put(136, 16);  // Hex
  	bases.put(137, 10);  // Decimal
  }
  
  // called every time in the draw loop
  public void update(TagLibrary tl, PGraphics pg) {

    /*
    initPrintScreen(pg, 0, height / 2);
    printScreen(pg, "Hello", false);
    printScreen(pg, 2, true);
    printScreen(pg, "World!", false);
    printScreen(pg, 2, true);
    */

    // Initialize Background
  	pg.background(0, 0, 128);

    List<TagRow> rows = tl.getTagRows();

    // Find the long row
    TagRow longRow = null;
    for (TagRow row : rows) {
    	if (row.size() > 1) {
      	if (longRow != null) {
      		System.out.println("Multiple Long Rows");
      		return;
      	} else {
      		longRow = row;
      	}
      }
    }
    if (longRow == null) {
      System.out.println("There is no long row");
      return;
    }

    // Read Input String
    int iBase;
    if (!isBase(longRow.get(0))) {
    	System.out.println("First tag in row not a base tag");
      return;
    } else {
    	iBase = base(longRow.get(0));
    }

    String input = "";
    for (int i = 1; i < longRow.size(); i++) {
    	Tag tag = longRow.get(i);
    	if (!isNumber(tag)) {
        System.out.println("Row contains non-number values");
    		return;
     	} else {
      	input += number(tag);
      }
    }

    // Convert Input String to Integer Value
    int value = Integer.parseInt(input, iBase);
    

    // Print Outputs Next to Other Base Tags
    for (TagRow row : rows) {
    	if (row.size() == 1) {
    		int oBase;
    		if (!isBase(row.get(0))) {
    			System.out.println("First tag in row not a base tag");
    			continue;
    		} else {
    			oBase = base(row.get(0));
    		}

    		String output = Integer.toString(value, oBase).toUpperCase();

        // System.out.println("Value = " + value + " Output = " + output);

        initPrintScreen(pg, row.getMaxX() + 20, row.getMaxY());

        printScreen(pg, output + " = ", false);
        for (int i = 0; i < output.length(); i++) {
          printScreen(pg, Integer.parseInt(Character.toString(output.charAt(i)), oBase), false);
          printScreen(pg, 'x', false);
          printScreen(pg, oBase, false);
          printScreen(pg, output.length() - i - 1, true);

          if (i + 1 < output.length()) printScreen(pg, " + ", false);
        }
    	}
    }
  }

  private String number(Tag tag) {
  	return numbers.get(tag.getId());
  }

  private boolean isNumber(Tag tag) {
  	return number(tag) != null;
  }

  private Integer base(Tag tag) {
  	return bases.get(tag.getId());
  }

  private boolean isBase(Tag tag) {
    return base(tag) != null;
  }

  private void printOutput(TagRow row, String output, PGraphics pg) {
    initPrintScreen(pg, row.getMinX() + 100 , row.getMaxY());
    printScreen(pg, output, false);
  }

  private void initPrintScreen(PGraphics pg, double x, double y) {
    this.x = (float) x;
    this.y = (float) y;

    pg.fill(255, 255, 0);
    // pg.noStroke();
  }

  private void  printScreen(PGraphics pg, int i, boolean exponent) {
    printScreen(pg, Integer.toString(i), exponent);
  }


  private void printScreen(PGraphics pg, String s, boolean exponent) {
    for (char c : s.toCharArray()) {
      printScreen(pg, c, exponent);
    }
  }

  private void printScreen(PGraphics pg, char c, boolean exponent) {
    if (exponent) pg.textSize(32);
    else pg.textSize(64);

    if (exponent) pg.text(c, x, y - 30);
    else pg.text(c, x, y);

    x += pg.textWidth(c);
  }
}
