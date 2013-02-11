/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */
 
// Pin 13 has an LED connected on most Arduino boards.
// give it a name:
int led = 13;
int s_delay = 100;
int o_delay = 300;

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(led, OUTPUT);     
}

// the loop routine runs over and over again forever:
void loop() {
  s();
  delay(400);
  o();
  delay(400);
  s();
  delay(1000);
}

void s() {
  for (int i = 0; i < 3; i++) {
   high();
   delay(s_delay);
   low();
   delay(s_delay); 
  }
}

void o() {
  for (int i = 0; i < 3; i++) {
   high();
   delay(o_delay); 
   low();
   delay(o_delay);
  }
}

void high() {
   digitalWrite(led, HIGH); 
}

void low() {
  digitalWrite(led, LOW);
}
