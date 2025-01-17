//This demo triggers a text display with each new message
// Works with 1 classifier output, any number of classes
//Listens on port 12000 for message /wek/outputs (defaults)

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;


//No need to edit:
PFont myFont, myBigFont;
final int myHeight = 400;
final int myWidth = 400;
int frameNum = 0;
int currentHue = 100;
int currentTextHue = 255;
String currentMessage = "";

void setup() {
    size(400,400, P3D);

  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  colorMode(HSB);
  smooth();
  background(255);
  
  String typeTag = "f";
  //myFont = loadFont("SansSerif-14.vlw");
  myFont = createFont("Arial", 14);
  myBigFont = createFont("Arial", 80);
}
//draw, med baggrundsopdatering, hvor farven ændres altefter hvad variablen "currentHue" er. Det er også her vi kalder drawText.
void draw() {
  frameRate(30);
  background(currentHue, 255, 255);
  drawText();
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println("received message");
    if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      if(theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      println("received1");
       showMessage((int)f);
      }
    }
 
}
//Her tager vi vores osc besked og generere farven på baggrunden.
void showMessage(int i) {
    currentHue = (int)generateColor(i);
    currentTextHue = (int)generateColor((i+1));
    //Her laves der et "if else" statement, som spørger efter hvilken en klasse, der er på skærmen. Herefter ændres teksten og farven på skærmen efter hvilken klasse det er.
    
    if(i == 1){
        currentMessage = "";
        currentHue = 20;
    } else if (i == 2){
    currentMessage = "Hejsa";
    currentHue = 0;
    } else if(i == 3){
    currentMessage = "Hænderne op";
    } else if(i == 4){
    currentMessage = "kys";
    } else if (i == 5){
    currentMessage = "Fortnite er objektivt et dårligt spil";
    }
    
  
}

//Write instructions to screen.
void drawText() {
    stroke(0);
    textFont(myFont);
    //vi sætter teksten i midten 
    textAlign(LEFT, CENTER); 
    fill(currentTextHue, 255, 255);

    text("Receives 1 classifier output message from wekinator", 10, 10);
    text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
    
    textFont(myBigFont);
    text(currentMessage, 190, 180);
}


float generateColor(int which) {
  float f = 100; 
  int i = which;
  if (i <= 0) {
     return 100;
  } 
  else {
     return (generateColor(which-1) + 1.61*255) %255; 
  }
}
