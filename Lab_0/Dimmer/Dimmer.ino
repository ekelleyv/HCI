//Flex sensor mapping
//adapted from http://garagelab.com/profiles/blogs/tutorial-flex-sensor-with-arduino
/*
Light based laser tags.
*/
int max_val = 120;

int red = 3;
int green = 6; 

void setup()
{
    // initialize serial communications
    Serial.begin(9600); 
    pinMode(red, OUTPUT);
    pinMode(green, OUTPUT);
}

void loop()
{
    int sensor, deg;

    // read the voltage from the voltage divider (sensor plus resistor)
    sensor = analogRead(2);

    deg = map(sensor, 640, 700, -1*max_val, max_val);

    // print out the result
    Serial.print("analog input: ");
    Serial.print(sensor,DEC);
    Serial.print(" degrees: ");
    Serial.println(deg,DEC);
    
    if (deg < 0) {
      controlRed(abs(deg));
      controlGreen(0);
    }
    else {
      controlGreen(deg);
      controlRed(0);
    }

    // pause before taking the next reading
    delay(100); 
}

// Yellow LED control
void controlGreen(int index) {
 analogWrite(yellow, min(index, 255));
}

// Red LED control
void controlRed(int index) {
 analogWrite(red, min(index, 255));
}
