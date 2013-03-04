const int groundpin = A2; // analog input pin 2

const int powerpin = A0; // analog input pin 0

const int xpin = A5; // x-axis of the accelerometer

const int ypin = A4; // y-axis

const int zpin = A3; // z-axis 

void setup()

{

 // initialize the serial communications:

 Serial.begin(9600);

 // Provide ground and power by using the analog inputs as normal

 // digital pins. This makes it possible to directly connect the

 // breakout board to the Arduino. If you use the normal 5V and

 // GND pins on the Arduino, you can remove these lines.

 pinMode(groundpin, OUTPUT);

 pinMode(powerpin, OUTPUT);

 digitalWrite(groundpin, LOW); 

 digitalWrite(powerpin, HIGH);

}

void loop()

{

 // print the sensor values:

 Serial.print(analogRead(xpin));

 // print a tab between values:

 Serial.print("\t");

 Serial.print(analogRead(ypin));

 // print a tab between values:

 Serial.print("\t");

 Serial.print(analogRead(zpin));

 Serial.println();

 // delay before next reading:
 delay(100);

}
