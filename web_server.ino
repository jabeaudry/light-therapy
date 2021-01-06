//ESP8266 instructions found on:
//https://www.instructables.com/Programming-a-HTTP-Server-on-ESP-8266-12E/
//getting the time instrcutions found on:
//https://lastminuteengineers.com/esp8266-ntp-server-date-time-tutorial/


#include <NTPClient.h>
#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <SoftwareSerial.h>

//sets the wires going to the Uno
SoftwareSerial fromUno(D4, D5); //Rx, Tx
WiFiServer server(80); //Initialize the server on Port 80
int totalSteps = 0;
const long utcOffsetInSeconds = (-18000);    //sets the time to EST

//define NTP client
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", utcOffsetInSeconds);

//time variables
int hour;
int minu;
int sec;

void setup() {
Serial.begin(115200);
fromUno.begin(115200);  //sets the uno
WiFi.mode(WIFI_AP); //Our ESP8266-12E is an AccessPoint
WiFi.softAP("Chip", "ShortVix"); // Provide the (SSID, password); .
server.begin(); // Start the HTTP Server
Serial.begin(115200); //Start communication between the ESP8266-12E and the monitor window
IPAddress HTTPS_ServerIP= WiFi.softAPIP(); // Obtain the IP of the Server
Serial.print("Server IP is: "); // Print the IP to the monitor window
Serial.println(HTTPS_ServerIP);

timeClient.begin();    //begins the time
}

void loop() {
timeSet();
stepTaken();
WiFiClient client = server.available();
if (!client) {
return;
}
//Looking under the hood

//Read what the browser has sent into a String class and print the request to the monitor
String request = client.readStringUntil('\r');;
//Looking under the hood
//Serial.println(request);
client.println("<!DOCTYPE html><html>");
client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"></head>");
client.println("<body><p id = \"num\">");
client.print(totalSteps+".");
client.println("</p></body></html>");


}
//this function gets the time and sets it
//at midnight, the steps are reset
void timeSet(){
hour = (timeClient.getHours());
minu = (timeClient.getMinutes());
sec = (timeClient.getSeconds());
   //resets the steps at midnight
  if (hour == 0 && minu == 0 && sec == 0){
    totalSteps = 0;
    
  }

  delay(300);
}


//this function adds steps if the arduino has sent any
void stepTaken() {
 if (fromUno.available())
  {
  char  sent = fromUno.read();
  if (sent=='a'){
      totalSteps++;
      delay(500);
       
    }
  }
}
