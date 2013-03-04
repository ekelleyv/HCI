#include <CapacitiveSensor.h>


/*
 * CapitiveSense Library Demo Sketch
 * Paul Badger 2008
 * Uses a high value resistor e.g. 10 megohm between send pin and receive pin
 * Resistor effects sensitivity, experiment with values, 50 kilohm - 50 megohm. Larger resistor values yield larger sensor values.
 * Receive pin is the sensor pin - try different amounts of foil/metal on this pin
 * Best results are obtained if sensor foil and wire is covered with an insulator such as paper or plastic sheet
 */
 
int speakerPin = 7;

int threshold = 3000;


CapacitiveSensor   cs_0 = CapacitiveSensor(3,8);        // 10 megohm resistor between pins 4 & 2, pin 2 is sensor pin, add wire, foil

CapacitiveSensor   cs_2 = CapacitiveSensor(2,10);        // 10 megohm resistor between pins 4 & 2, pin 2 is sensor pin, add wire, foil

CapacitiveSensor   cs_4 = CapacitiveSensor(4,12);        // 10 megohm resistor between pins 4 & 2, pin 2 is sensor pin, add wire, foil

CapacitiveSensor   cs_6 = CapacitiveSensor(6,13);        // 10 megohm resistor between pins 4 & 2, pin 2 is sensor pin, add wire, foil

void playTone(int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(speakerPin, HIGH);
    delayMicroseconds(tone);
    digitalWrite(speakerPin, LOW);
    delayMicroseconds(tone);
  }
}

void playNote(char note, int duration) {
  char names[] = { 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C' };
  int tones[] = { 1915, 1700, 1519, 1432, 1275, 1136, 1014, 956 };

  // play the tone corresponding to the note name
  for (int i = 0; i < 8; i++) {
    if (names[i] == note) {
      playTone(tones[i], duration);
    }
  }
}



void setup()                    
{

   cs_0.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
   cs_2.set_CS_AutocaL_Millis(0xFFFFFFFF);
   cs_4.set_CS_AutocaL_Millis(0xFFFFFFFF);
   cs_6.set_CS_AutocaL_Millis(0xFFFFFFFF);
   
   pinMode(speakerPin, OUTPUT);
   
   Serial.begin(9600);

}

//void loop() {
//  for (int i = 0; i < length; i++) {
//    if (notes[i] == ' ') {
//      delay(beats[i] * tempo); // rest
//    } else {
//      playNote(notes[i], beats[i] * tempo);
//    }
//
//    // pause between notes
//    delay(tempo / 2); 
//  }
//}

void loop()                    
{
//    long start = millis();
    
    long total_0 =  cs_0.capacitiveSensor(30);
    
    long total_2 =  cs_2.capacitiveSensor(30);
    
    long total_4 =  cs_4.capacitiveSensor(30);
    
    long total_6 =  cs_6.capacitiveSensor(30);
    
    Serial.print(total_0);
    Serial.print("\t");
    Serial.print(total_2);
    Serial.print("\t");
    Serial.print(total_4);
    Serial.print("\t");
    Serial.println(total_6);
    
    if (total_0 > threshold) {
     playNote('c', 100); 
    }
    
    if (total_2 > threshold) {
     playNote('d', 100); 
    }
    
    if (total_4 > threshold) {
     playNote('e', 100); 
    }
    
    if (total_6 > threshold) {
     playNote('f', 100); 
    }
    

//    Serial.print(millis() - start);        // check on performance in milliseconds
//    Serial.print("\t");                    // tab character for debug windown spacing
//
//    Serial.println(total);                  // print sensor output 1
    

    delay(10);                             // arbitrary delay to limit data to serial port 
}
