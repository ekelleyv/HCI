class Assembly {

  int regA;
  int regB;
  int regC;
  int regD;
  int im_width;
  int im_height;
  int[] output;
  int output_count;

  Assembly (int im_width, int im_height) {
    output = new int[10];
    output_count = 0;
    this.im_width = im_width;
    this.im_height = im_height;
    regA = 0;
    regB = 1;
    regC = 2;
    regD = 3;
  }

  void update(PGraphics pg, int[] regs) {
    pg.beginDraw();
    draw_grid(pg);
    update_reg_vals(pg, regs);
    draw_output(pg);
    pg.endDraw();
    //println("Ended Assembly update");
  }

  void add_output(int val) {
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
    pg.rect(10, 10, width-15, height-15);

    //Center Line
    pg.fill(160, 160, 160);
    pg.line(width/2-5, 10, width/2-5, height);

    //Code header
    pg.textSize(32);
    pg.textAlign(CENTER, CENTER);
    pg.text("Code", width/4, 40);

    //Memory/Output Line
    pg.line(width/2, height/4, width, height/4);

    pg.text("Output", 3*width/4, height/4 + 40);

    pg.fill(217, 105, 0);
    pg.rect(width/2, 10, width/8-9, height/4-10);
    pg.fill(255, 187, 0);
    pg.rect(5*width/8, 10, width/8-9, height/4-10);
    pg.fill(217, 102, 111);
    pg.rect(6*width/8, 10, width/8-9, height/4-10);
    pg.fill(4, 117, 100);
    pg.rect(7*width/8, 10, width/8-9, height/4-10);


    pg.fill(255);
    pg.text("A", 9*width/16, 40);
    pg.text("B", 11*width/16, 40);
    pg.text("C", 13*width/16, 40);
    pg.text("D", 15*width/16, 40);
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
    pg.text(val, offset*width/16, 120);
  }

  void draw_output(PGraphics pg) {
    pg.fill(255);
    pg.textSize(32);
    int output_start = output_count - 15;
    if (output_start < 0) {
      output_start = 0;
    }
    for (int i = output_start; i < output_count; i++) {
      pg.text(output[i], width/2+80, height/4+80 + (i-output_start)*32);
    }
  }

}
