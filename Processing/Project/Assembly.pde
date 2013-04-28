class Assembly {

  int regA;
  int regB;
  int regC;
  int regD;
  int im_width;
  int im_height;
  String[] output;
  int output_count;

  Assembly (int im_width, int im_height) {
    output = new String[10];
    output_count = 0;
    this.im_width = im_width;
    this.im_height = im_height;
    regA = 0;
    regB = 1;
    regC = 2;
    regD = 3;
  }
  
  void clear_output() {
    output_count = 0;
  }

  void update(PGraphics pg, int[] regs, List<TagRow> tag_rows, int eip, boolean isRunning) {
    pg.beginDraw();
    draw_grid(pg);
    update_reg_vals(pg, regs);
    draw_output(pg);
    if (tag_rows.size() > 0) draw_status(pg, tag_rows, eip, isRunning);
    pg.endDraw();
    //println("Ended Assembly update");
  }

  void add_output(String val) {
    if (output_count == output.length) {
      output = expand(output);
    }
    output[output_count++] = val;
  }

  void draw_grid(PGraphics pg) {
    pg.background(0);
    pg.noFill();

    //Border
    pg.stroke(160);
    pg.strokeWeight(10);
    pg.rect(10, 10, im_width-15, im_height-15);

    //Center Line
    pg.fill(160, 160, 160);
    pg.line(im_width/2-5, 10, im_width/2-5, im_height);

    //Code header
    pg.textSize(32);
    pg.textAlign(CENTER, CENTER);
    pg.text("Code", im_width/4, 40);

    //Memory/Output Line
    pg.line(im_width/2, im_height/4, im_width, im_height/4);

    pg.text("Output", 3*im_width/4, im_height/4 + 40);

    pg.fill(21, 60, 214);
    pg.rect(im_width/2, 10, im_width/8-9, im_height/4-10);
    pg.fill(201, 18, 0);
    pg.rect(5*im_width/8, 10, im_width/8-9, im_height/4-10);
    pg.fill(254, 200, 111);
    pg.rect(6*im_width/8, 10, im_width/8-9, im_height/4-10);
    pg.fill(37, 159, 100);
    pg.rect(7*im_width/8, 10, im_width/8-9, im_height/4-10);


    pg.fill(255);
    pg.text("A", 9*im_width/16, 40);
    pg.text("B", 11*im_width/16, 40);
    pg.text("C", 13*im_width/16, 40);
    pg.text("D", 15*im_width/16, 40);
  }

  void update_reg_vals(PGraphics pg, int[] regs) {
    draw_val(regA, regs[0], pg);
    draw_val(regB, regs[1], pg);
    draw_val(regC, regs[2], pg);
    draw_val(regD, regs[3], pg);
  }

  void draw_val(int num, int val, PGraphics pg) {
    int offset = num*2+9;
    pg.fill(255);
    pg.textSize(64);
    if (val > 1000) {
      pg.textSize(40);
    }
    pg.text(val, offset*im_width/16, 120);
  }

  void draw_status(PGraphics pg, List<TagRow> tag_rows, int eip, boolean isRunning) {
    TagRow row = tag_rows.get(eip);
    double minX = row.getMinX()-100;
    double minY = row.getMinY();
    double rowHeight = row.Height();
    double midY = minY + rowHeight / 2.0;

    int size = 20;

    int textX = im_width/2 - 70;
    int textY = im_height - 90;
    
    if (isRunning) {
      pg.fill(255);
    pg.triangle((float) minX - size, (float) midY - size/2, (float) minX, (float) midY, (float) minX - size, (float) midY+size/2);
      pg.fill(160, 160, 160);
      pg.text("Running!", textX, textY);
    }
    else {
      pg.fill(160, 160, 160);
      pg.text("Waiting...", textX, textY);
    }
  }

  void draw_output(PGraphics pg) {
    pg.fill(255);
    pg.textSize(32);
    int output_start = output_count - 15;
    if (output_start < 0) {
      output_start = 0;
    }
    for (int i = output_start; i < output_count; i++) {
      pg.text(output[i], im_width/2+80, im_height/4+80 + (i-output_start)*32);
    }
  }

}