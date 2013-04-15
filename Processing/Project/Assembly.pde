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
    regB = 0;
    regC = 0;
    regD = 0;
  }

  void update(PGraphics pg, int[] regs) {
    pg.beginDraw();
    draw_grid(pg);
    update_reg_vals(pg, regs);
    draw_output(pg);
  }

  void add_output(int val) {
    if (output_count == output.length) {
      output = expand(output);
    }
    output[output_count++] = val;
  }

  void draw_grid(PGraphics pg) {
    background(0);
    noFill();

    //Border
    stroke(255);
    strokeWeight(10);
    rect(10, 10, width-15, height-15);

    //Center Line
    fill(255, 255, 255);
    line(width/2-5, 10, width/2-5, height);

    //Code header
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Code", width/4, 40);

    //Memory/Output Line
    line(width/2, height/4, width, height/4);

    text("Output", 3*width/4, height/4 + 40);

    fill(217, 105, 0);
    rect(width/2, 10, width/8-9, height/4-10);
    fill(255, 187, 0);
    rect(5*width/8, 10, width/8-9, height/4-10);
    fill(217, 102, 111);
    rect(6*width/8, 10, width/8-9, height/4-10);
    fill(4, 117, 100);
    rect(7*width/8, 10, width/8-9, height/4-10);


    fill(255);
    text("A", 9*width/16, 40);
    text("B", 11*width/16, 40);
    text("C", 13*width/16, 40);
    text("D", 15*width/16, 40);
  }

  void update_reg_vals(PGraphics pg, int[] regs) {
    draw_val(regA, regs[0]);
    draw_val(regB, regs[1]);
    draw_val(regC, regs[2]);
    draw_val(regD, regs[3];
  }

  void draw_val(int val, int num) {
    int offset = num*2+9;
    fill(255);
    textSize(64);
    if (val > 1000) {
      textSize(40);
    }
    text(val, offset*width/16, 120);
  }

  void draw_output(PGraphics pg) {
    fill(255);
    textSize(32);
    int output_start = output_count - 15;
    if (output_start < 0) {
      output_start = 0;
    }
    for (int i = output_start; i < output_count; i++) {
      text(output[i], width/2+80, height/4+80 + (i-output_start)*32);
    }
  }

}
