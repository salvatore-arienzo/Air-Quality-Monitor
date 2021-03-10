#include <MQUnifiedsensor.h> //gas sensor library
#include <DHT.h> //humidity sensor library
#include <SoftwareSerial.h> //Bluetooth library

SoftwareSerial HM19(1, 0); // RX = 2, TX = 3 // Bluetooth pin definition
String data= ""; //the string we will broadcast with Bluetooth

//Definition of pins:

/* HUMIDITY SENSOR SECTION */
#define DHTPINA 11
#define DHTPINB 10
#define DHTTYPE DHT11

DHT dhtA(DHTPINA, DHTTYPE);
DHT dhtB(DHTPINB, DHTTYPE);

/* DUST SENSOR SECTION */

#define USE_AVG
const int sharpLEDPin = 7;   // Arduino digital pin 7 connect to sensor LED.
const int sharpVoPin = A5;   // Arduino analog pin 5 connect to sensor Vo.

// For averaging last N raw voltage readings on Dust sensor
#ifdef USE_AVG
#define N 100
static unsigned long VoRawTotal = 0;
static int VoRawCount = 0;
#endif // USE_AVG

// Set the typical output voltage in Volts when there is zero dust. 
static float Voc = 0.6;

// Use the typical sensitivity in units of V per 100ug/m3.
const float K = 0.3;


/* GAS SENSOR SECTION */

#define board "Arduino UNO"
#define Voltage_Resolution 5
#define pin A0 //Analog input 0 of your arduino
#define type "MQ-135" //MQ135
#define ADC_Bit_Resolution 10 // For arduino UNO/MEGA/NANO
#define RatioMQ135CleanAir 3.6//RS / R0 = 3.6 ppm  

MQUnifiedsensor MQ135(board, Voltage_Resolution, ADC_Bit_Resolution, pin, type);


//Helper functions to format strings  
void printValue(String text, unsigned int value, bool isLast = false) {
  Serial.print(text);
  Serial.print("=");
  Serial.print(value);
  if (!isLast) {
    Serial.print(", ");
  }
}
void printFValue(String text, float value, String units, bool isLast = false) {
  Serial.print(text);
  Serial.print("=");
  Serial.print(value);
  Serial.print(units);
  if (!isLast) {
    Serial.print(", ");
  }
}


void setup() {
  // Set LED pin for output.
  pinMode(sharpLEDPin, OUTPUT);
  Serial.begin(9600);
  HM19.begin(9600);
 
  //setup humidity sensors
  dhtA.begin();
  dhtB.begin();

  //setup gas sensor
  MQ135.setRegressionMethod(1); //_PPM =  a*ratio^b
  MQ135.setA(102.2); 
  MQ135.setB(-2.473);
  MQ135.setR0(39.93); //r0 calculated
  MQ135.init();  

 //CALIBRATION OF GAS SENSOR ----- Not need to calibrate always, only if we modify the setup
  //Serial.print("Calibrating please wait.");
  float calcR0 = 0;
  for(int i = 1; i<=10; i ++)
  {
    MQ135.update(); // Update data, the arduino will be read the voltage on the analog pin
    calcR0 += MQ135.calibrate(RatioMQ135CleanAir);
    Serial.print(".");
  }
  MQ135.setR0(calcR0/10);
  //Serial.println("  done!.");
  
  //if(isinf(calcR0)) {Serial.println("Warning: Conection issue founded, R0 is infite (Open circuit detected) please check your wiring and supply"); while(1);}
 // if(calcR0 == 0){Serial.println("Warning: Conection issue founded, R0 is zero (Analog pin with short circuit to ground) please check your wiring and supply"); while(1);}
  
  
  //Serial.println("********************************* SENSORS MEASUREMENTS *************************");
  delay(2000);
}

void loop() {
 readValues();  
}


void readValues(){ //dust sensor value measurement
  digitalWrite(sharpLEDPin, LOW);
  // Wait 0.28ms before taking a reading of the output voltage as per spec.
  delayMicroseconds(280);
  // Record the output voltage. This operation takes around 100 microseconds.
  int VoRaw = analogRead(sharpVoPin);
  // Turn the dust sensor LED off by setting digital pin HIGH.
  digitalWrite(sharpLEDPin, HIGH);
  // Wait for remainder of the 10ms cycle = 10000 - 280 - 100 microseconds.
  delayMicroseconds(9620);
  // Print raw voltage value (number from 0 to 1023).
  //#ifdef PRINT_RAW_DATA
  //printValue("VoRaw", VoRaw, true);
  //Serial.println("");
  //#endif // PRINT_RAW_DATA
 
  // Use averaging if needed.
  float Vo = VoRaw;
  #ifdef USE_AVG
  VoRawTotal += VoRaw;
  VoRawCount++;
  
  if ( VoRawCount >= N ) {
    Vo = 1.0 * VoRawTotal / N;
    VoRawCount = 0;
    VoRawTotal = 0;
  } else {
    return;
  }
  #endif // USE_AVG
  

  // Compute the output voltage in Volts.
  
  Vo = Vo / 1024.0 * 5.0;
  //printFValue("Vo", Vo*1000.0, "mV");

  // Convert to Dust Density in units of ug/m3.
  float dV = Vo - Voc;
  if ( dV < 0 ) {
    dV = 0;
    Voc = Vo;
  }
  float dustDensity = dV / K * 100.0;
  //printFValue("DustDensity", dustDensity, "ug/m3", true);
  //Serial.println(""); 
  data = String(dustDensity);
  measureGasses();
  }

void measureGasses(){//gas sensor measuerement
   //gas sensor
  //Serial.println("********************************* GAS SENSOR VALUES *************************");
  //Serial.println("|      CO    |   Alcohol   |    CO2   |   Tolueno   |    NH4   |   Acteona  |");  
  MQ135.update(); // Update data, the arduino will be read the voltage on the analog pin
  MQ135.setA(605.18); MQ135.setB(-3.937); // Configurate the ecuation values to get CO concentration
  float CO = MQ135.readSensor(); // Sensor will read PPM concentration using the model and a and b values setted before or in the setup

  MQ135.setA(77.255); MQ135.setB(-3.18); // Configurate the ecuation values to get Alcohol concentration
  float Alcohol = MQ135.readSensor(); // Sensor will read PPM concentration using the model and a and b values setted before or in the setup

  MQ135.setA(110.47); MQ135.setB(-2.862); // Configurate the ecuation values to get CO2 concentration
  float CO2 = MQ135.readSensor(); // Sensor will read PPM concentration using the model and a and b values setted before or in the setup

  MQ135.setA(44.947); MQ135.setB(-3.445); // Configurate the ecuation values to get Tolueno concentration
  float Tolueno = MQ135.readSensor(); // Sensor will read PPM concentration using the model and a and b values setted before or in the setup

  MQ135.setA(102.2 ); MQ135.setB(-2.473); // Configurate the ecuation values to get NH4 concentration
  float NH4 = MQ135.readSensor(); // Sensor will read PPM concentration using the model and a and b values setted before or in the setup

  MQ135.setA(34.668); MQ135.setB(-3.369); // Configurate the ecuation values to get Acetona concentration
  float Acetona = MQ135.readSensor(); // Sensor will read PPM concentration using the model and a and b values setted before or in the setup
/*
  Serial.print("|   "); Serial.print(CO); 
  Serial.print("       |"); Serial.print(Alcohol);
  Serial.print("       |   "); Serial.print(CO2 + 400); 
  Serial.print("       |   "); Serial.print(Tolueno); 
  Serial.print("       |   "); Serial.print(NH4); 
  Serial.print("       |   "); Serial.print(Acetona);
  Serial.println("   |"); */
  int Co2add = CO2 + 400;
  data = data + ","+String(CO) + "," + String(Alcohol) + "," + String(Co2add) + "," + String(Tolueno) + "," + String(NH4)+ "," + String(Acetona);
  
  delay(1000);
  measureHumidity();
  }

  void measureHumidity(){ //humidity sensors measurements
    //Serial.println("********************************* HUMIDITY SENSOR VALUES *************************");
    delay(2000);
    float h = dhtA.readHumidity();
    float g = dhtB.readHumidity();
    /*Serial.print(F("Humidity: "));
    Serial.print(h);
    Serial.println(F("% "));

    Serial.print(F("Humidity: "));
    Serial.print(g);
    Serial.println(F("% "));*/
    
    data = data + ","+String(h)  + ","+String(g);
        
    measureTemperature();   
    }

    void measureTemperature(){ //temperature sensors measurements
      delay(2000);
   // Serial.println("********************************* TEMPERATURE SENSOR VALUES *************************");
    float t = dhtA.readTemperature();
    float d = dhtB.readTemperature();
    // Read temperature as Celsius
   /* Serial.print("Temperature: ");
    Serial.print(t);
    Serial.println("°C ");
     Serial.print("Temperature: ");
    Serial.print(d);
    Serial.println("°C ");
    Serial.println("********************************* DUST SENSOR VALUES *************************");*/
    data = data + ","+String(t)  + ","+String(d);
    Serial.println(data);
    HM19.println(data);
    data = ""; //empty the string
    delay(2000);
      }
