#include <MQUnifiedsensor.h> //gas sensor library
#include <DHT.h> //humidity sensor library
#include <SoftwareSerial.h> //Bluetooth library

SoftwareSerial HM19(1, 0); // RX = 2, TX = 3 // Bluetooth pin definition
String data= ""; //the string we will broadcast with Bluetooth

#define DHTPIN 11
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);

#define USE_AVG
const int sharpLEDPin = 7;   
const int sharpVoPin = A5;   

// For averaging last N raw voltage readings on Dust sensor
#ifdef USE_AVG
#define N 100
static unsigned long VoRawTotal = 0;
static int VoRawCount = 0;
#endif // USE_AVG

static float Voc = 0.6;
const float K = 0.3;

#define board "Arduino UNO"
#define Voltage_Resolution 5
#define pin A0 //Analog input 0 of your arduino
#define type "MQ-135" //MQ135
#define ADC_Bit_Resolution 10 // For arduino UNO/MEGA/NANO
#define RatioMQ135CleanAir 3.6//RS / R0 = 3.6 ppm  

MQUnifiedsensor MQ135(board, Voltage_Resolution, ADC_Bit_Resolution, pin, type);

void setup() {
  pinMode(sharpLEDPin, OUTPUT);
  Serial.begin(9600);
  HM19.begin(9600);
  
  dht.begin();

  MQ135.setRegressionMethod(1); //_PPM =  a*ratio^b
  MQ135.setA(102.2); 
  MQ135.setB(-2.473);
  MQ135.init();  

 //CALIBRATION OF GAS SENSOR ----- Not need to calibrate always, only if we modify the setup
  float calcR0 = 0;
  for(int i = 1; i<=10; i ++)
  {
    MQ135.update();
    calcR0 += MQ135.calibrate(RatioMQ135CleanAir);
  }
  MQ135.setR0(calcR0/10);
  delay(2000);
}

void loop() {
 readValues();  
}


void readValues(){ 
  digitalWrite(sharpLEDPin, LOW);
  delayMicroseconds(280);
  int VoRaw = analogRead(sharpVoPin);
  digitalWrite(sharpLEDPin, HIGH);
  delayMicroseconds(9620);
  
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

  // Convert to Dust Density in units of ug/m3.
  float dV = Vo - Voc;
  if ( dV < 0 ) {
    dV = 0;
    Voc = Vo;
  }
  float dustDensity = dV / K * 100.0;
  
  data = String(dustDensity);
  measureGasses();
  }

void measureGasses(){//gas sensor measuerement
    
  MQ135.update(); 
  MQ135.setA(605.18); MQ135.setB(-3.937); 
  float CO = MQ135.readSensor(); 

  MQ135.setA(77.255); MQ135.setB(-3.18);
  float Alcohol = MQ135.readSensor();

  MQ135.setA(110.47); MQ135.setB(-2.862); 
  float CO2 = MQ135.readSensor(); 

  MQ135.setA(44.947); MQ135.setB(-3.445); 
  float Tolueno = MQ135.readSensor();

  MQ135.setA(102.2 ); MQ135.setB(-2.473); 
  float NH4 = MQ135.readSensor(); 

  MQ135.setA(34.668); MQ135.setB(-3.369); // Configurate the ecuation values to get Acetona concentration
  float Acetona = MQ135.readSensor(); // Sensor will read PPM concentration using the model and a and b values setted before or in the setup

  int Co2add = CO2 + 400;
  data = data + ","+String(CO) + "," + String(Alcohol) + "," + String(Co2add) + "," + String(Tolueno) + "," + String(NH4)+ "," + String(Acetona);
  
  delay(1000);
  measureHumidity();
  }

  void measureHumidity(){ 
    delay(2000);
    float h = dht.readHumidity();
    
    data = data + ","+String(h);
        
    measureTemperature();   
    }

    void measureTemperature(){ //temperature sensors measurements
      delay(2000);
  
    float t = dht.readTemperature();
   
    data = data + ","+String(t);
    Serial.println(data);
    HM19.println(data);
    data = ""; //empty the string
    delay(2000);
   }
