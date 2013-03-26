/*
Adafruit Arduino - Lesson 14. Knob
*/
int R = 2;
int L = 3;

int rLight = 0;
int lLight = 1;

void setup() 
{ 
  pinMode(R, OUTPUT);
  pinMode(L, OUTPUT);
  Serial.begin(9600);
  while (! Serial);
  Serial.println("Speed 0 to 255");

} 
 
 
void loop() 
{ 
  int rRead = analogRead(rLight);
  int lRead = analogRead(lLight);
  int rSpeed = map(rRead, 0, 300, 0, 255);
  int lSpeed = map(lRead, 700, 900, 0, 255);
  Serial.print("rSpeed: ");
  Serial.print(rRead);
  Serial.print(" lSpeed: ");
  Serial.println(lRead);
      analogWrite(R, lSpeed);
      analogWrite(L, rSpeed);
} 
