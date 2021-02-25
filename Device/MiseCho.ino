#include <SPI.h>
#include <WiFiNINA.h>
#include <ArduinoHttpClient.h>
#include <pm2008_i2c.h>
#include <ArduinoJson.h>

// WiFi
const char ssid[] = "********";     // Wifi name
const char pass[] = "********";   // Wifi password
int status = WL_IDLE_STATUS;

// HOST
const char Hostname[] = "***.***.***.***";        // host IP
const char GetPath[] = "/api/device/data/1/";   // Get PATH
const char PostPath[] = "/api/device/data/";    // POST PATH

WiFiClient wifi_client;
HttpClient http(wifi_client, Hostname);
PM2008_I2C pm2008;

void setup() {
  // Initalize serial and wait for port to open
  Serial.begin(9600);

  // Wifi Connect
  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);

  WiFi.begin(ssid, pass);

  pm2008.begin();
  pm2008.command();
  delay(1000);
}

void loop() {
  // Wifi Connect
  Serial.print("Attempting to connect to WPA SSID: ");
  Serial.println(ssid);

  while (WiFi.begin(ssid, pass) != WL_CONNECTED) {
    Serial.print("failed...");
    delay(4000);
    Serial.println("retrying...");
  }

  Serial.println("WiFi connected");
  
  // GET PMfreq
  Serial.println("making GET request");
  int err = 0;
  int PMfreq = 0;

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
      PMfreq = response.toInt();
    }
  }
  else {
    Serial.print("Connect failed : ");
    Serial.println(err);
  }

  // POST PM Data
  Serial.println("making POST request");
  String contentType = "application/json";

  uint8_t ret = pm2008.read();
  if (ret == 0) {
    int PM10 = pm2008.pm10_grimm;
    int PM2p5 = pm2008.pm2p5_grimm;

    Serial.print("PM10 : ");
    Serial.println(PM10);
    Serial.print("PM2.5 : ");
    Serial.println(PM2p5);

    DynamicJsonDocument doc(1024);
    doc["pm10"] = PM10;
    doc["pm25"] = PM2p5;
    doc["d_id"] = 1;
    String postData;
    serializeJson(doc, postData);
    Serial.print(postData);

    err = http.post(PostPath, contentType, postData);
    if (err == 0){
      Serial.println("startedRequest OK");
      int statusCode = http.responseStatusCode();
      String response = http.responseBody();
      if (statusCode >= 0){
        Serial.print("Got status code: ");
        Serial.println(statusCode);
        Serial.print("Body: ");
        Serial.println(response);
      }
    }
    else{
      Serial.print("Connect failed : ");
      Serial.println(err);
    }
  }
  unsigned long delaytime = PMfreq * 60000;
  delay(delaytime);
}
