//Adapted from http://garagelab.com/profiles/blogs/tutorial-flex-sensor-with-arduino

int max_val = 120;

int red = 3;
int yellow = 6; 

void setup()
{
    // initialize serial communications
    Serial.begin(9600); 
    pinMode(red, OUTPUT);
    pinMode(yellow, OUTPUT);
}

void loop()
{
    int sensor, deg;

    // read the voltage from the voltage divider (sensor plus resistor)
    sensor = analogRead(2);

    deg = map(sensor, 640, 700, -1*max_val, max_val);
    // note that the above numbers are ideal, your sensor's values will vary
    // to improve the accuracy, run the program, note your sensor's analog values
    // when it's straight and bent, and insert those values into the above function.

    // print out the result
    Serial.print("analog input: ");
    Serial.print(sensor,DEC);
    Serial.print(" degrees: ");
    Serial.println(deg,DEC);
    
    if (deg < 0) {
      controlRed(abs(deg));
      controlYellow(0);
    }
    else {
      controlYellow(deg);
      controlRed(0);
    }

    // pause before taking the next reading
    delay(100); 
}

// Yellow LED control
void controlYellow(int index) {
// Serial.print("Setting yellow to ");
// Serial.println(index, DEC);
 analogWrite(yellow, min(index, 255));
}

// Red LED control
void controlRed(int index) {
// Serial.print("Setting red to ");
// Serial.println(index, DEC);
 analogWrite(red, min(index, 255));
}
