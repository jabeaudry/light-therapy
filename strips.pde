OPC opc;
import processing.net.*;
PImage rectangle;
float hue = 0;

//time variables
int second = 0;
int hour = 0;
int day = 0;
int minute = 0;
int month = 0;
int year = 0;
boolean firstRun = true;   //variable used for the first run

//these variables will store the ints of the sunset/sunrise/noon minutes and hours
int noonMin;
int noonHour;
int riseMin;
int riseHour;
int setMin;
int setHour;

//these Strings will hold the day and month ints as Strings
String dayString;
String monthString;

//holds the hours between noon and the sunrise
int morningLength = 0;

//holds the hours between noon and the sunset
int afternoonLength = 0;


//json array (holds sunrise/sunset times)
JSONArray values;

 //this variable will determine how many lights are on
double recWidth = 0;
int recX = 0;
int recY = 0;
  
//temp boolean that knows if it is raining
boolean rain = false;
boolean cloud = false;

 //bytes stored when reading the server

    
BufferedReader reader;
String line;


//int that hold the color values for the lights
int red = 0;
int green = 0;
int blue = 0;
boolean flash = false;

//steps taken value
float steps = 0;

//step variables in fn of time
int stepHour = 0;
float lastSteps = 0;
int firstStep = 0;

void setup()
{
  //led map size
  size(600, 600, P3D);
  //sets the lef colours
  colorMode(RGB, 100);
  
 //testing
  rectangle = loadImage("rectangle.png");
  
  //sets the json variable to the json file
  values = loadJSONArray("sun_movement_2020.json");
  

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);
  

  // Map one 64-LED strip to the center of the window
  // Map 8 strips of 15 pixels each

for (int i = 0; i < 8; i ++){
  opc.ledStrip(15*i, 15, ((width/8)*(i+0.7)), height*0.5,7, 1.571, true);
  //sets up the first reference values
lastSteps = steps;
 stepHour = hour;
}
}


//this method determines the date and the times the sun will set
void getTime() {
    //get time
  second = second();
  minute = minute();
  hour = hour();
  day = day();
  month = month();
  year = year();

  
  
  //converts the day and month to Strings
  if (day < 10) {
    dayString = "0"+str(day);     //adds a zero to the day format
  }
  else {
    dayString = str(day);
  }
  
  if (month < 10) {
    monthString = "0"+str(month);   //adds a zero to the month format
  }
  else {
    monthString = str(month);
  }
    
  
  //reads all the values of each day, one by one
  //only executes once a day at midnight
  if ((hour == 0 && minute == 1)|| firstRun == true){
  
  for (int i = 0; i < values.size(); i++) {
    
    JSONObject selectedDay = values.getJSONObject(i); 

    String dateStr = selectedDay.getString("Date");
    String sunriseStr = selectedDay.getString("Sunrise");
    String noonStr = selectedDay.getString("Local noon");
    String sunsetStr = selectedDay.getString("Sunset");
    
    if (dateStr.equals("2020-"+monthString+"-"+dayString)) {
      String currentSunrise = sunriseStr;
      String currentNoon = noonStr;
      String currentSunset = sunsetStr;
      
      //sets the sunrise/sunset/noon times to hour/minute ints
      //sunrise
             //testing
             //println(currentNoon);
             //println(currentSunrise);
      riseHour = int(currentSunrise.substring(0,2));
      riseMin = int(currentSunrise.substring(3,5));
              println(riseMin);
              println(riseHour);
      
       //sunset
      setHour = int(currentSunset.substring(0,2));
      setMin = int(currentSunset.substring(3,5));
      
      //noon
      noonHour = int(currentNoon.substring(0,2));
      noonMin = int(currentNoon.substring(3,5));
      //println(riseMin);
      //determines the hours between noon and the sunrise/sunset
      morningLength = (noonHour - riseHour);
      afternoonLength = (setHour - noonHour);
    }
    
    
    
   
  }
  }
  firstRun = false;    //this lets processing know that the time loop is not 0
}

//this method executes when the sun rises
//it turns on the lights like the sunrise
void isSunrise() {
  if ((hour == riseHour)&&(minute > riseMin)) {
    recX = 0;
    recY = 0;
    recWidth = (width*0.15);
  }
}



//this method executes when the sun has set or when the sun is not up yet
void isNight() {
  if (((hour <= riseHour)&&(minute < riseMin))||((hour >= setHour)&&(minute > setMin))){
    recX = 0;
    recY = 0;
    recWidth = 0;
    steps = 0;
  }
}

//this function gages how much time there is before noon and determines the lights on
void beforeNoon() {
  if (((hour > riseHour)&&(hour < noonHour))){
    recX = 0;
    recY = 0;
    double morningRatio = (1-(((double)noonHour-(double)hour)/((double)morningLength)));
    recWidth = width*morningRatio;
    //sets the last steps taken every hour during the day
    if (minute == 0 && second == 0){
      lastSteps = steps;
      stepHour = hour;
    }
  }
  }
  
//this function gages how much time there is before sunset and determines the lights on
void afterNoon() {
  if ((hour < setHour)&&(hour > noonHour)){
    double afternoonRatio = (((double)hour-(double)noonHour)/((double)afternoonLength));
    recWidth = width*(1-afternoonRatio);
    recX = (int)(width*afternoonRatio);
    recY = 0;
    println(afternoonRatio);
    println(recWidth);
    //sets the last steps taken every hour during the day
    if (minute == 0 && second == 0){
      lastSteps = steps;
      stepHour = hour;
    }
  }
}
//this function will execute during the hour that noon falls on (not always 12)
void isNoon() {
 if (hour == noonHour){
   recWidth = width*0.6;
   recX = width/8;
 }
}
  
  //this method uses the Open Weater Map API every 15 minutes
  //I am using Westmount as a reference point
  //I will be checking the temperature every 15 minutes by fetching a JSON file associated with the location (Westmount)
  //the lights should change colour once it starts raining
  
  void getWeather() {
  if (((minute == 30) || (minute == 00) || (minute ==15) || (minute == 45))&&(second == 0)){
  JSONObject weather;   //will store the JSON file 
  String temp;   //stores current temp as a string
  weather = loadJSONObject("http://api.openweathermap.org/data/2.5/weather?q=Westmount&appid=92d3c8a276c2cbb30d1c30aa0687f2ef&units=metric");  //gets the json file online
  JSONArray weatherArr = weather.getJSONArray("weather");
  JSONObject weatherObj = weatherArr.getJSONObject(0);
  temp = weatherObj.getString("main");
  println("Weather:", temp);
  temp = "cloud";
  
  //check for rain, if it is raining, it will set the rain variable to true
     if(temp.equals("Rain")){
      rain = true;
      }
      else {
        rain = false;
      }
      // if the current weather is cloudy, sets the cloud variable to true
      if(temp.equals("Clouds")){
        cloud = true;
      }
      else {
      cloud = false;
      }
      delay(300);        //vital component, prevents the code from looping infinitely
      
  }
  }
  //if less than 10 steps were taken in the last hour
void lastSteps(){
  if (stepHour+1 == hour && lastSteps+10 > steps && minute < 1){
    red = 100;
    green = 0;
    blue = 0;
  }
  
}
  //determines the colour of the lights
void determineTint() {
 
  //colour if it is raining
  if (rain == true) {
  red = 90;
  green = 95;
  blue = 45;
   if (steps > 100){
  flash = false;
  }
  }
  //during the morning, blue to wake up
  else if (steps >= 50 && steps < 100){
    red = 10;
    blue = 4;
    green = 40;
      if (steps > 100){
  flash = false;
  }
  }
  //colour in the morning
  else if(steps < 50 && steps > 4){
  
    flash = true;
 

  }
  else if (cloud == true) {
  red = 100;
  green = 95;
  blue = 90;
  if (steps > 100){
  flash = false;
  }
  
  }
  
  //sunset light
  else if ((setHour-hour)==1) {
   red = 100;
   green = 20;
   blue = 50;
     if (steps > 100){
  flash = false;
  }
  }
  //once I walk enough
  else if (setHour > hour && hour < riseHour && steps> 2000) {
   red = 80;
    green = 50;
    blue = 45;
     if (steps > 100){
  flash = false;
  }
  
  }
  else {
    red = 90;
    green = 60;
    blue = 65;
      if (steps > 100){
  flash = false;
  }
  }
  lastSteps();
}

void getSteps() {
 
  
  //connects with the client
  //in this case the pedometer
  //reads the frst String
  
  Client thisClient;
  thisClient = new Client(this, "192.168.4.1", 80);
 try{
      if (thisClient != null) { //thisClient control
        String incomingMsg = thisClient.readString();
        if (incomingMsg != null) { //incomingMsg string control
          steps = parseFloat(incomingMsg);
        }
      }
    }catch(NullPointerException e){ 
      println("Null Pointer when storing incomingMsg string.");
    
}
}
//changes the behaviour of the lights based on my steps
void fromFirstStep(){
  
  //sets the variables
  if (hour == 0) {
   firstStep = 0; 
  }
  if (steps == 4){
    firstStep = hour;
  }
  
  //time to eat
  if (firstStep+4 == hour){
    red = 50;
    green = 20;
    blue = 22;
  }
  
  
  //if I walk too much around the evening
   if (stepHour+1 == hour && lastSteps+20 < steps && minute < 1){
    if (second%2 ==0){
    int t;
    for ( t = 50; t >= 0; t--){
    tint(t, 10, 0);
    delay(9);
    }
  }
   }
  else {
    delay(10);
    for (int g = 0; g <= 50; g++){
    tint(g, 10, 0);
    delay(9);
    }
    }
  }
  
  

void draw()
{
  getTime();      //this functions sets the day's important times
  getSteps();     //gets the amount of steps from the client
  isSunrise();      //this function only excutes when it is sunrise
  isNight();        //this function only executes after sunset or before sunrise
  beforeNoon();      //this function gages how much time there is before noon and determines the lights on
  afterNoon();        //this function gages how much time there is before sunset and determines the lights on
  isNoon();          //executes when it is noon
  getWeather();      //this function will check the current weather
  background(0);
 
 // getSteps();
  //println(riseHour);
  //println(noonHour);
 // println(noonMin);
 
  //draw the rectangle that determines which lights are on
  image(rectangle, recX, recY, (int)recWidth, height);
  determineTint();
  fromFirstStep();    //adds light behaviour in function of time of first steps
  println(steps);
  tint(red, green, blue);
  if (flash == true){
  if (second%2 ==0){
    int t;
    for ( t = 100; t >= 0; t--){
    tint(0, t, 0);
    delay(9);
    }
  }
  else {
    delay(10);
    for (int g = 0; g <= 100; g++){
    tint(0, g, 0);
    delay(9);
    }
    }
 
  }

}
