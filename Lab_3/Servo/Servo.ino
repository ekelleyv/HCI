/*
Adafruit Arduino - Lesson 14. Knob
*/

#include <Servo.h> 

int lightPin = 1;  
int servoPin = 9;
Servo servo; 
 
void setup() 
{ 
  servo.attach(servoPin);
  Serial.begin(9600);  
} 
 
void loop() 
{ 
  int reading = analogRead(lightPin);     // 0 to 1023
  Serial.println(reading);
  int angle = map(reading, 500, 1000, 0, 180);
  servo.write(angle);  
} 
