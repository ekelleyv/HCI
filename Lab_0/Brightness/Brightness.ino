/*
  Individually controls brightness of LEDs
 */
 
// Pin 13 has an LED connected on most Arduino boards.
// give it a name:
int yellow = 3;
int green = 5;
int red = 6;   
int index = 1;
boolean up = false;
int max_val = 120;

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
  controlGreen((index+40)%max_val);
  controlRed((index+80)%max_val);
  
  index += 1;
  if (index == max_val) {
    index = 0;
  }
  
  delay(10);
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
