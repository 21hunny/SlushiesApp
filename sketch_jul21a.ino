#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>

// Wi-Fi credentials
const char* ssid = "lasindupc";
const char* password = "lasindu96";

// Firestore REST API details
const char* host = "firestore.googleapis.com";
const int httpsPort = 443;
const char* projectId = "slushiesapp";
const char* apiKey = "AIzaSyA6uwbW2Y45kV236nILthzFmVGspJXkw_s";

// Base path for Firestore API requests
const String basePath = "/v1/projects/" + String(projectId) + "/databases/(default)/documents";

// Pin mapping (Relays are Active LOW)
const int juice1Pin = D6; // Mango
const int juice2Pin = D5; // Orange
const int sugarPin  = D7;
const int waterPin  = D8;

// Variable to store the ID of the last processed order in memory
String lastProcessedOrderId = "";

BearSSL::WiFiClientSecure client;

// ** Super simple approach: just read everything and find any JSON **
String getFixedResponse() {
  // Skip HTTP headers
  while (client.connected()) {
    String line = client.readStringUntil('\n');
    if (line == "\r") {
      break; // Headers are done
    }
  }

  // Read the entire body into memory
  String rawResponse = "";
  while (client.connected() || client.available()) {
    if (client.available()) {
      rawResponse += client.readString();
    }
    delay(10);  // Small delay to allow more data to arrive
  }

  Serial.println("Raw response:");
  Serial.println(rawResponse);

  // Look for the beginning of a JSON object
  int objectStart = rawResponse.indexOf('{');
  if (objectStart == -1) {
    return "";  // No JSON found
  }

  // Look for the end of the JSON object
  int objectEnd = rawResponse.lastIndexOf('}');
  if (objectEnd == -1) {
    return "";  // No complete JSON found
  }

  // Extract the JSON object and wrap it in array brackets
  String jsonObject = rawResponse.substring(objectStart, objectEnd + 1);
  return "[" + jsonObject + "]";
}


void setup() {
  Serial.begin(115200);
  Serial.println("\nBooting up with Array Forcing Method...");

  pinMode(juice1Pin, OUTPUT);
  pinMode(juice2Pin, OUTPUT);
  pinMode(sugarPin, OUTPUT);
  pinMode(waterPin, OUTPUT);

  digitalWrite(juice1Pin, HIGH);
  digitalWrite(juice2Pin, HIGH);
  digitalWrite(sugarPin, HIGH);
  digitalWrite(waterPin, HIGH);

  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi connected.");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  configTime(0, 0, "pool.ntp.org", "time.nist.gov");
  Serial.print("Waiting for NTP time sync: ");
  time_t now = time(nullptr);
  while (now < 8 * 3600 * 2) {
    delay(500);
    Serial.print(".");
    now = time(nullptr);
  }
  Serial.println("\nTime synced.");

  client.setInsecure();
  client.setTimeout(10000); // 10-second timeout
}

void loop() {
  fetchAndProcessOrder();
  Serial.println("--------------------");
  delay(15000);
}

void fetchAndProcessOrder() {
  Serial.println("Fetching latest successful order...");

  if (!client.connect(host, httpsPort)) {
    Serial.println("Connection to host failed!");
    return;
  }

  String url = basePath + ":runQuery?key=" + String(apiKey);
  
  String queryPayload = R"({
    "structuredQuery": {
      "from": [{"collectionId": "orders"}],
      "where": {
        "fieldFilter": {"field": {"fieldPath": "paymentStatus"}, "op": "EQUAL", "value": {"stringValue": "Success"}}
      },
      "orderBy": [{"field": {"fieldPath": "timestamp"}, "direction": "DESCENDING"}],
      "limit": 1
    }
  })";

  client.print(String("POST ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" +
               "Content-Type: application/json\r\n" +
               "Content-Length: " + queryPayload.length() + "\r\n" +
               "Connection: close\r\n\r\n" +
               queryPayload);

  String responsePayload = getFixedResponse();
  client.stop();
  
  if (responsePayload.isEmpty()) {
      Serial.println("No valid payload received from server.");
      return;
  }

  Serial.println("Cleaned JSON Payload:");
  Serial.println(responsePayload);
  
  StaticJsonDocument<2048> doc;
  DeserializationError error = deserializeJson(doc, responsePayload);

  if (error) {
    Serial.print("Failed to parse JSON: ");
    Serial.println(error.c_str());
    return;
  }
  
  // The response is an array, check the first element.
  if (doc.as<JsonArray>().size() == 0 || doc[0]["document"].isNull()) {
    Serial.println("No successful orders found or response was an error.");
    return;
  }

  JsonObject orderDoc = doc[0]["document"];
  String docName = orderDoc["name"];
  String currentOrderId = docName.substring(docName.lastIndexOf('/') + 1);

  Serial.println("Latest order ID found: " + currentOrderId);
  Serial.println("Last processed order ID: " + (lastProcessedOrderId.isEmpty() ? "None" : lastProcessedOrderId));

  if (currentOrderId != lastProcessedOrderId) {
    Serial.println(">>> This is a new order! Processing... <<<");
    
    String juice = orderDoc["fields"]["juiceType"]["stringValue"];
    bool sugar = orderDoc["fields"]["addSugar"]["booleanValue"];
    bool water = orderDoc["fields"]["addWater"]["booleanValue"];
    
    processOrder(juice, sugar, water);
    lastProcessedOrderId = currentOrderId;
    Serial.println(">>> Processing complete. New last processed ID is: " + lastProcessedOrderId);

  } else {
    Serial.println("This order has already been processed. Waiting for a new one.");
  }
}

void processOrder(String juice, bool sugar, bool water) {
  Serial.printf("Order details: Juice: %s, Sugar: %s, Water: %s\n", juice.c_str(), sugar ? "Yes" : "No", water ? "Yes" : "No");

  if (juice == "Mango Juice") {
    Serial.println("Turning ON Mango Juice relay (Pin D6 LOW)...");
    digitalWrite(juice1Pin, LOW); delay(3000); 
    Serial.println("Turning OFF Mango Juice relay (Pin D6 HIGH)...");
    digitalWrite(juice1Pin, HIGH);
  } else if (juice == "Pineapple Juice") {
    Serial.println("Turning ON Pineapple Juice relay (Pin D5 LOW)...");
    digitalWrite(juice2Pin, LOW); delay(3000);
    Serial.println("Turning OFF Pineapple Juice relay (Pin D5 HIGH)...");
    digitalWrite(juice2Pin, HIGH);
  }

  if (sugar) {
    Serial.println("Turning ON Sugar relay (Pin D7 LOW)...");
    digitalWrite(sugarPin, LOW); delay(1000);
    Serial.println("Turning OFF Sugar relay (Pin D7 HIGH)...");
    digitalWrite(sugarPin, HIGH);
  }

  if (water) {
    Serial.println("Turning ON Water relay (Pin D8 LOW)...");
    digitalWrite(waterPin, LOW); delay(2000);
    Serial.println("Turning OFF Water relay (Pin D8 HIGH)...");
    digitalWrite(waterPin, HIGH);
  }
}