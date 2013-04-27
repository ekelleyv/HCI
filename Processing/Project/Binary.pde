import java.util.*;

public class Binary implements Application {

	private HashMap<Integer, String> numbers = new HashMap<Integer, String>();
	private HashMap<Integer, Integer> bases = new HashMap<Integer, Integer>();

  public void init(int im_width, int im_height) {
  	// Add the numbers to the library
  	for (int i = 0; i < 16; i++) {
      numbers.put(i, Integer.toString(i, 16).toUpperCase());
    }


    // Add the bases to the library
    bases.put(17, 2);   // Binary
  	bases.put(18, 8);   // Octal
  	bases.put(19, 16);  // Hex
  	bases.put(20, 10);  // Decimal
  }
  
  // called every time in the draw loop
  public void update(TagLibrary tl, PGraphics pg) {
    try {
  	pg.background(0);

    List<TagRow> rows = tl.getTagRows();

    // Find the long row
    TagRow longRow = null;
    for (TagRow row : rows) {
    	if (row.size() > 1) {
      	if (longRow != null) {
      		// System.out.println("Multiple Long Rows");
      		return;
      	} else {
      		longRow = row;
      	}
      }
    }
    if (longRow == null) {
      // System.out.println("There is no long row");
      return;
    }

    // Read Input String
    int iBase;
    if (!isBase(longRow.get(0))) {
    	// System.out.println("First tag in row not a base tag");
      return;
    } else {
    	iBase = base(longRow.get(0));
    }

    String input = "";
    for (int i = 1; i < longRow.size(); i++) {
    	Tag tag = longRow.get(i);
    	if (!isNumber(tag)) {
    		// System.out.println("Row contains non-number values");
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
    			// System.out.println("First tag in row not a base tag");
    			return;
    		} else {
    			oBase = base(row.get(0));
    		}

    		String output = Integer.toString(value, oBase).toUpperCase();
        // System.out.println("Value = " + value + " Output = " + output);

    		printOutput(row, output, pg);
    	}
    }
    } catch(Exception e) {
      // System.out.println("Why error!!!");
      return;
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
    pg.fill(255);
    // pg.noStroke();
    pg.textSize(128);
    pg.text(output, (float) row.getMinX() + 400, (float) row.getMaxY());
  }
}
