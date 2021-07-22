# Interactive Light Therapy
This project utilizes the Arduino Uno R3 board, the Arduino IDE, Processing, the ADX1335 sensor, the NodeMCU ESP8266 and some LED strips. 

![image](https://user-images.githubusercontent.com/56971054/126576711-17460607-84f3-4223-a0c7-87310c51a2b8.png) ![image](https://user-images.githubusercontent.com/56971054/126576723-3799c75c-f604-4f4b-9822-9f1a66ac6c7a.png)




Image may contain: indoor, wall and home appliance
a rainy day around noon
the sunset
night time
  
Abstract

It is 7 a.m., Eastern Time. You wake up. You look through your window. It is still dark outside, but you can discern last night's snowfall that coats your neighbor's trees. You then check the current temperature on your phone. Minus 32 degrees Celsius. Nice, you will stay inside today. It is 7 a.m., but a day has now passed. You have work. You check outside your window. Still dark. You come back home after work around 6 p.m. The sun is already gone. Wherever you go, it seems like you are constantly chasing the sun, but can never catch it. You are always a few minutes late. As winter progresses, your mood sours. You call it "winter's blues".

The Idea

Along with the winter of 2021 came another challenge: COVID-19. Like many students, I spent 99.9% of my time locked inside an apartment bedroom. Since I couldn't tie down the sun and keep it all to myself, I had to look elsewhere. In other words, I had to create my own sun. I thus decided that the best way to alleviate the symptoms of seasonal affective disorder for someone that doesn't have many windows was simply to create them. This solution would directly fix my problem and could possibly help anyone in the same situation. 


Arduino coding light light therapy processing
The initial model

Apart from staying inside, quarantine had also limited my physical activity. By limited, I mean obliterated into non-existence. Exercise, along with light therapy, go hand in hand to alleviate winter's lack of sunlight.
I decided to build the following: 

1. A light source that would replicate the outside world in terms of weather and time.
2. A pedometer that would impact the amount of light produced, depending on my movement. Less movement, more light. 

The Final Prototype
Image may contain: indoor, floor and wall
Image may contain: wall and indoor
Image may contain: indoor and wall
1. The light source
The "window" was built using 300 addressable LEDs, a wooden frame and a 12V battery. The lights are controlled using the AdaFruit FadeCandy driver and Processing. They move and change color depending on the time of the day, as well as sunset/sunrise times based on my position. The WeatherAPI is also used to determine the weather and influence the color of the lights. 



2. The pedometer
The tool to count the steps was created with the combination of the Arduino Uno R3, the Adafruit ADXL335 and the the nodeMCU firmware. The accelerometer counted the steps, which were then processed by the Arduino.  The information was then sent to the nodeMCU esp8266, which would create a webserver that contained the live number of steps. Processing would finally fetch the number and adapt the lighting accordingly. 
