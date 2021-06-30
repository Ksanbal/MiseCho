#include <SPI.h>
#include <EEPROM.h>
#include <WiFiNINA.h>
#include <ArduinoHttpClient.h>
#include <ArduinoJson.h>
#include <pm2008_i2c.h>


// ** WiFi 정보 입력하는 곳 ** 
//---------------------------------
char ssid[] = "WiFi SSID";   // WiFi 이름
char pass[] = "WiFi Password";   // WiFi 비밀번호 
//---------------------------------

// RYG PIN
const int RED_PIN = 13;
const int YELLOW_PIN = 12;
const int GREEN_PIN = 11;

int status = WL_IDLE_STATUS;

// HOST
const char Hostname[] = "000.000.000.000";        // host IP
const char GetPath[] = "/api/device/data/1/";   // Get PATH
const char PostPath[] = "/api/device/data/";    // POST PATH
WiFiClient wifi_client;
HttpClient http(wifi_client, Hostname);

// PM Sensor
PM2008_I2C pm2008;

void setup() {
  pinMode(RED_PIN, OUTPUT);
  pinMode(YELLOW_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  
  Serial.begin(9600);
  LED_status(8);
  delay(500);
  
  Serial.print("SSID : ");
  Serial.println(ssid);
  Serial.print("PASSWORD : ");
  Serial.println(pass);
  
  // WiFi 목록에 입력된 SSID가 있는지 확인
  if (!ScanAndCheckWiFi(ssid)) {
    LED_status(3);
    Serial.println("Not found input ssid from scan wifi list");
    while (true);
  }

  // WiFi 연결
  // Connect to WPA/WPA2 network:
  status = WiFi.begin(ssid, pass);

  // wait 10 seconds for connection:
  delay(10000);
  
  // LED GREEN'
  LED_status(4);

  // Run PM Sensor
  Serial.println("\n** Run PM Sensor **");
  pm2008.begin();
  pm2008.command();
}

void loop() {
  // WiFi 체크
  while (status != WL_CONNECTED) {
    // LED YEELOW WiFi 연결중
    LED_status(2);
    Serial.print("Attempting to connect to WPA SSID: ");
    Serial.println(ssid);

    // Connect to WPA/WPA2 network:
    status = WiFi.begin(ssid, pass);

    // wait 10 seconds for connection:
    delay(10000);
  }
  Serial.println("You're connected to the network");

  // API GET
  int PMFreq = GetPMFreq();

  // PM GET
  String PMdata = GetPM();
  Serial.println(PMdata);

  // API POST
  PostData(PMdata);

  // Wait to next delayTime
  unsigned long delaytime = PMFreq * 60000;
  delay(delaytime);
}

bool ScanAndCheckWiFi(char inputssid[]) {
  Serial.println("\n** Scan Networks **");
  int numSsid = WiFi.scanNetworks();

  if (numSsid == -1) {
    Serial.println("Couldn't get a WiFi connection");
    while (true);
  }

  // print the list of networks seen:
  Serial.print("number of available networks:");
  Serial.println(numSsid);

  // print the network number and name for each network found:
  for (int thisNet = 0; thisNet < numSsid; thisNet++) {
    Serial.print(thisNet);
    Serial.print(") ");
    Serial.print(WiFi.RSSI(thisNet));
    Serial.print("\t");
    Serial.println(WiFi.SSID(thisNet));

    if (strcmp(WiFi.SSID(thisNet), inputssid) == 0) {
      Serial.println("Found!");
      Serial.println();
      return true;
    }
  }

  Serial.println("Not found!\n");
  return false;
}

int GetPMFreq() {
  Serial.println("\n** Making GET request **");
  int err = 0;
  int freq = 0;

  err = http.get(GetPath);
  if (err == 0) {
    Serial.println("startedRequest OK");
    int statusCode = http.responseStatusCode();
    String response = http.responseBody();
    if (statusCode >= 0) {
      Serial.print("Got status code: ");
      Serial.println(statusCode);
      Serial.print("Body: ");
      Serial.println(response);
      freq = response.toInt();
      return freq;
    }
  }
  else {
    LED_status(7);
    Serial.print("Connect failed : ");
    return 0;
  }
}

String GetPM() {
  Serial.println("\n** PM Sensing **");
  uint8_t ret = pm2008.read();
  int PM10;
  int PM2p5;

  if (ret == 0) {
    PM10 = pm2008.pm10_grimm;
    PM2p5 = pm2008.pm2p5_grimm;

    Serial.print("PM10 : ");
    Serial.println(PM10);
    Serial.print("PM2.5 : ");
    Serial.println(PM2p5);
  }else{
    LED_status(5);
  }

  DynamicJsonDocument doc(1024);
  doc["pm10"] = PM10;
  doc["pm25"] = PM2p5;
  doc["d_id"] = 1;
  String postData;
  serializeJson(doc, postData);

  return postData;
}

void PostData(String data) {
  Serial.println("\n** Making POST request **");
  int err = 0;
  String contentType = "application/json";
  err = http.post(PostPath, contentType, data);

  if (err == 0) {
    Serial.println("startedRequest OK");
    int statusCode = http.responseStatusCode();
    String response = http.responseBody();
    if (statusCode >= 0) {
      Serial.print("Got status code: ");
      Serial.println(statusCode);
      Serial.print("Body: ");
      Serial.println(response);
    }
  }
  else {
    LED_status(6);
    Serial.print("Connect failed : ");
    Serial.println(err);
  }
}

void TurnOn(int Pin){
  digitalWrite(Pin, HIGH);
}

void TurnOff(int Pin){
  digitalWrite(Pin, LOW);
}

void LED_status(int code){
  TurnOff(RED_PIN);
  TurnOff(YELLOW_PIN);
  TurnOff(GREEN_PIN);
  
  switch(code){
    case 1:
      break;

    case 2:
      // WiFi 연결실패
      TurnOn(RED_PIN);
      break;

    case 3:
      // WiFi 목록에 없음
      TurnOn(YELLOW_PIN);
      break;

    case 4:
      // 준비완료
      TurnOn(GREEN_PIN);
      break;

    case 5:
      // PM 센서 이상
      TurnOn(YELLOW_PIN);
      TurnOn(RED_PIN);
      break;

    case 6:
      // API GET 실패
      TurnOn(GREEN_PIN);
      TurnOn(RED_PIN);
      break;
      
    case 7:
      // API POST 실패
      TurnOn(GREEN_PIN);
      TurnOn(YELLOW_PIN);
      break;

    case 8:
      // 전원켜짐
      TurnOn(RED_PIN);
      TurnOn(YELLOW_PIN);
      TurnOn(GREEN_PIN);
      break;
  }
}
