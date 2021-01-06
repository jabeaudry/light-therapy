
//This code is used with the ADX1335 sensor to build a pedometer.
//the sensor takes into account the movement on the X, Y and Z axis, which is then used to calculate steps.
//This code was found and adapted on the following website:
//http://arduinoprojectsforbeginners.blogspot.com/2018/07/measuring-steps-using-adxl335.html


#include <SoftwareSerial.h>


SoftwareSerial toESP(11, 12); //Rx, Tx
int xpin=A3;
  int ypin=A2;
  int zpin=A1;
  int powerpin=A4;
  int gnd=A0;
  float threshhold=130.0;
  float xval[100]={0};
  float yval[100]={0};
  float zval[100]={0};
  float xavg;
  float yavg;
  float zavg;
 int steps = 0;
  int state=0;
  void setup()
  {
  toESP.begin(115200);
    Serial.begin(115200);
  pinMode(powerpin,OUTPUT);
  pinMode(gnd,OUTPUT);
  digitalWrite(powerpin,HIGH);
  digitalWrite(gnd,LOW);
  //pinMode(13,OUTPUT);
  calibrate();
  }void loop()
  {
  
  resetSteps();
  int acc=0;
  float totvect[100]={0};
  float totave[100]={0};
  float xaccl[100]={0};
  float yaccl[100]={0};
  float zaccl[100]={0}; 
  for (int i=0;i<100;i++){
  xaccl[i]=float(analogRead(xpin));
  yaccl[i]=float(analogRead(ypin));
  zaccl[i]=float(analogRead(zpin));
  totvect[i] = sqrt(((xaccl[i]-xavg)* (xaccl[i]-xavg))+ ((yaccl[i] - yavg)*(yaccl[i] - yavg)) + ((zval[i] - zavg)*(zval[i] -zavg)));
  totave[i] = (totvect[i] + totvect[i-1]) / 2 ;

  delay(300);
  //calculating number of steps 
  if (totave[i]<threshhold && state==0){
  steps=steps+1;
  
  toESP.write("a");
  Serial.write("a");
  delay(1500);
  state=1;
  
  }
  if (totave[i] <threshhold  && state==1)
  {state=0;}
 

  };
  delay(1000);
  }
  void calibrate(){
  float sum=0;
  float sum1=0;
  float sum2=0;
  for (int i=0;i<100;i++){
  xval[i]=float(analogRead(xpin));
  sum=xval[i]+sum;
  }
  delay(100);
  xavg=sum/100.0;
  
  for (int j=0;j<100;j++){
  xval[j]=float(analogRead(xpin));
  sum1=xval[j]+sum1;
  }
  yavg=sum1/100.0;
 
  delay(100);
  for (int i=0;i<100;i++){
  zval[i]=float(analogRead(zpin));
  sum2=zval[i]+sum2;
  }
  zavg=sum2/100.0;
  delay(100);
 
  }

  void resetSteps() {
    if (steps > 20000) {
      steps = 0;
     }
  }
  
  
  
