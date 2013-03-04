import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Response extends PApplet {

// Graphing sketch
//Adapted from http://arduino.cc/en/Tutorial/Graph 



 Serial myPort;        // The serial port
 int xPos = 1;         // horizontal position of the graph

 int zero_pos;
 int one_pos;
 float max_pos;
 float min_pos;


 
 public void setup () {
	 // set the window size:
	 size(1080, 720);
	 max_pos = height; 
	 min_pos = 0;       
	 
	 // List all the available serial ports
	 // println(Serial.list());
	 // I know that the first port in the serial list on my mac
	 // is always my  Arduino, so I open Serial.list()[0].
	 // Open whatever port is the one you're using.
	 myPort = new Serial(this, Serial.list()[0], 9600);
	 // don't generate a serialEvent() unless you get a newline character:
	 myPort.bufferUntil('\n');
	 // set inital background:
	 background(224,228,204); 
	}
	public void draw () {
 	// everything happens in the serialEvent()
 }
 
 public void serialEvent (Serial myPort) {
	 // get the ASCII string:
	 String inString = myPort.readStringUntil('\n');
	 
	 if (inString != null) {
		 // trim off any whitespace:
		 inString = trim(inString);

		 if (inString.length() != 0) {
		 	String[] sensor_strings = inString.split(" ");
		 	
		 	if (sensor_strings.length < 3) {
		 		println("RETURN");
		 		return;
		 	}

		 	float inByte = PApplet.parseFloat(sensor_strings[0]); 
		 	inByte = map(inByte, 0, 1023, 0, height/3);

		 	float yPos = height;
		// draw the line:
		stroke(105,210,231);
		line(xPos, yPos, xPos, yPos - inByte);
		yPos -= (inByte + 1);

		inByte = PApplet.parseFloat(sensor_strings[1]); 
		inByte = map(inByte, 0, 1023, 0, height/3);

		stroke(167,219,216);
		line(xPos, yPos, xPos, yPos - inByte);
		yPos -= (inByte + 1);


		inByte = PApplet.parseFloat(sensor_strings[2]); 
		inByte = map(inByte, 0, 1023, 0, height/3);

		stroke(250, 105, 0);
		line(xPos, yPos, xPos, yPos - inByte);

		
		if ((yPos-inByte) < max_pos) {
			max_pos = yPos-inByte;
		}
		if ((yPos-inByte) > min_pos) {
			min_pos = yPos-inByte;
		}
		drawMax(max_pos);
		drawMax(min_pos);


		 // at the edge of the screen, go back to the beginning:
		 if (xPos >= width) {
		 	xPos = 0;
		 	max_pos = yPos-inByte;
		 	min_pos = yPos-inByte;
		 	background(224,228,204); 
		 } 
		 else {
		 // increment the horizontal position:
		 xPos++;
		}
	}
}
}

public void drawMax(float max_pos) {
	stroke(255, 0, 0);
	ellipse(xPos, max_pos, 2, 2);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Response" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
