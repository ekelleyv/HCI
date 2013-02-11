/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */
 
// Pin 13 has an LED connected on most Arduino boards.
// give it a name:
int yellow = 3;
int green = 5;
int red = 6;   
int index = 0;

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(yellow, OUTPUT);     
  pinMode(green, OUTPUT);   
  pinMode(red, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  
  controlYellow(index);
  controlGreen(index);
  controlRed(index);
  
  index += 1;
  if (index == 255) {
    index = 0;
  }
  
  delay(5);
}

// Yellow LED control
void controlYellow(int index) {
 analogWrite(yellow, index);
}

// Green LED control
void controlGreen(int index) {
 analogWrite(green, index);
}

// Red LED control
void controlRed(int index) {
 analogWrite(red, index);
}
