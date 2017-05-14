import processing.sound.*;
SoundFile file = new SoundFile(this, "Twenty One Pilots - Stressed Out (Tomsize Remix).mp3");
String myText = "Enter the time in format hh:mm\n";
int [] Time;
boolean PROCESSED = false;
int Hours;
int Minutes;
void setup() {
  size(500, 500);
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(0);
  //file = new SoundFile(this, "Twenty One Pilots - Stressed Out (Tomsize Remix).mp3");
}

void draw() {
  background(255);
  text(myText, 0, 0, width, height); 
 // print(myText.length());
  print('\n');
  if (PROCESSED == false){
    if (myText.length() == 37){
      PROCESSED = true;
      ProcessInput();
    }
  }
  int m = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  String minutes = "";
  if (frameCount % 100 == 0)
  {
    if (m < 10)
    {
      minutes = "0"+str(m);
    }
    else
    {
      minutes = str(m);
    }
    print(minutes);
    delay(1000);
    print(h);
    //delay(1000);
    print(h, ":", minutes);
    print('\n');
    //delay(1000);
  }
  
  if (int(Hours) == int(h) && int(Minutes) == int(minutes)){
    print("AlarmWorks");
    delay(10000);
    file.play();
   // delay(10000);
  }
}

void keyPressed() {
  if (keyCode == BACKSPACE) {
    if (myText.length() > 0) {
      myText = myText.substring(0, myText.length()-1);
    }
  } else if (keyCode == DELETE) {
    myText = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    myText = myText + key;
  }
  if (keyCode == ENTER){
      print(myText);
  }
}

void ProcessInput(){
  //myText = myText.substring(31,36);
  print("FLAG");
  //delay(100);
  print(myText);
  //delay(1000);
  print("Hours");
  print(myText.substring(31,33));
  //delay(1000);
  print("Minutes");
  print(myText.substring(33,36));
  Hours = int(myText.substring(31,33));
  Minutes = int(myText.substring(33,36));
}