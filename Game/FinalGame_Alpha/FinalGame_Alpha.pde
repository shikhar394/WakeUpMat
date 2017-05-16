//Ball[] balls = new Ball[10];
import processing.sound.*;
import KinectPV2.KJoint;
import KinectPV2.*;
import processing.serial.*;
//import processing.sound.*;
SoundFile Alarmfile; 
Serial myPort;
int valueFromArduino;
String myText = "Enter the time for alarm in format hh:mm\n";
int [] Time;
boolean PROCESSED = false;
boolean ALARM_PLAY = false;
boolean VAL_ARDUINO = false;
boolean JOINT_FOOT = true;
boolean GAME_SOUND_PLAY = false;
boolean SONG_PLAY = false;
String User_Hours = "";
String User_Minutes = "";
String Comp_minutes = "";
String Comp_hours = "";
KinectPV2 kinect;
int ALARM_MODE = 0;
int GAME_MODE = 1;
int CUR_MODE = 0;
int CONG_MESSAGE = 2;
int GOAL_MESSAGE = 3;
int ALARM_STOP_MODE = 4;
int BallsKicked = 0;
int BallsPunched = 0;
int MaxScore = 3000;
int MaxBallsKicked = 400;
int MaxBallsPunched = 400;
int start_frame = 0;
ArrayList<Ball> Balls = new ArrayList<Ball>();
int Score;
SoundFile Gamefile;
PFont font;

void setup() 
{
  String [] fonts= PFont.list();
  printArray(fonts);
  font= createFont("Impact", 30);
  textFont(font);
  //size(1600, 900, P3D); //16:9
  fullScreen(P3D);
  noStroke();

  //printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  frameRate(30);
  textAlign(CENTER, CENTER);
  ellipseMode(RADIUS);
  Gamefile = new SoundFile(this, "Game.mp3");
  Alarmfile = new SoundFile(this, "Alarm.mp3");
  // create balls 
  for (int i =0; i<random(10); i++) {
    int size = int(random(20, 40));
    Balls.add(new Ball(random(width), random(height), size));
  }
  //Gamefile.play();

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
  textAlign(CENTER, CENTER);
  textSize(30);
}

void draw() 
{
  while (myPort.available() > 0) {
    valueFromArduino = myPort.read();
    println(valueFromArduino);
    if (valueFromArduino == 1) {
      VAL_ARDUINO = true;
    }
  }
  if (CUR_MODE == ALARM_MODE) {
    background(255);
    fill(0);
    text(myText, 0, 0, width, height); 
    print(myText.length());
    if (PROCESSED == false) {
      if (myText.length() == 47) {
        PROCESSED = true;
        print(PROCESSED);
        User_Minutes = myText.substring(44, 46);
        User_Hours = myText.substring(41, 43);
        print("Minutes User", User_Minutes);
        print("Hours User", User_Hours);
        //delay(10000);
      }
    }
    int m = minute();  // Values from 0 - 59
    int h = hour();    // Values from 0 - 23


    if (true)
    {
      if (m < 10)
      {
        Comp_minutes = "0"+str(m);
      } else
      {
        Comp_minutes = str(m);
      }
      if (h<10)
      {
        Comp_hours = "0" + str(h);
      } else
      {
        Comp_hours = str(h);
      }
      /*
      print(minutes);
       delay(1000);
       print(hours);
       delay(1000);
       print(hours, ":", minutes);
       print('\n');
       delay(1000);*/
    }
    String Time = "Current Time :" + Comp_hours + ":" + Comp_minutes;
    text(Time, 0, -100, width, height);

    if (PROCESSED == true) {
      print("FormattedFunction Hour", int(Comp_hours), '\n');
      print("Input Hours", int(User_Hours), '\n');
      print("FormattedMins", int(Comp_minutes), '\n');
      print("Input Minutes", int(User_Minutes), '\n');
      print("Game Mode", GAME_MODE, '\n');
      print("ALARM MODE", ALARM_MODE, '\n');
      print("Current Mode", CUR_MODE, '\n');
      print("Value from Arduino", valueFromArduino, "\n");
      //delay(10000);
    }

    if (User_Hours.equals(Comp_hours) && User_Minutes.equals(Comp_minutes)) {
      print("AlarmWorks");
      if (ALARM_PLAY == false) {
        ALARM_PLAY = true;
        CUR_MODE = ALARM_STOP_MODE;
      }
    }
    
  }
  if (CUR_MODE == GOAL_MESSAGE) {
    background(0);
    if (start_frame == 0)
      start_frame = frameCount;
    text("PUNCH 400 BALLS | KICK 400 BALLS | HIT 2000 BALLS IN TOTAL", 0, 0, width, height); 
    int end_frame = frameCount;
    print("Cur Frame", frameCount);
    if (end_frame - start_frame >= 100)
      CUR_MODE = GAME_MODE;
  }
  if (CUR_MODE == ALARM_STOP_MODE) {
    background(255);
    //text("CONGRATULATIONS, YOU WOKE UP!  ANOTHER DAY TO WIN AHEAD OF YOU!", 0, 0, width, height);
    text("STAND ON THE MAT TO START PLAYING THE GAME AND TO STOP THE ALARM", 0, 0, width, height);         
    ALARM_PLAY = true;
    if (SONG_PLAY == false) {
      SONG_PLAY = true;
      Alarmfile.play();
    }
    if (valueFromArduino == 1 && CUR_MODE != GAME_MODE && ALARM_PLAY == true) {
      //delay(10000)
      print("Going to game mode");
      CUR_MODE = GOAL_MESSAGE;
      Alarmfile.stop();
      //delay(10000);
    }
  }
  if (CUR_MODE == GAME_MODE) {
    background(0);

    image(kinect.getColorImage(), 0, 0, width, height);

    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
    if (GAME_SOUND_PLAY == false) {
      GAME_SOUND_PLAY = true;
      Gamefile.play();
    }
    //individual JOINTS
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();

        float x_Right = joints[KinectPV2.JointType_HandRight].getX();
        float y_Right = joints[KinectPV2.JointType_HandRight].getY();
        int handState_Right = joints[KinectPV2.JointType_HandRight].getState();
        float x_Left = joints[KinectPV2.JointType_HandLeft].getX();
        float y_Left = joints[KinectPV2.JointType_HandLeft].getY();
        float x_foot_left = joints[KinectPV2.JointType_FootLeft].getX();
        float y_foot_left = joints[KinectPV2.JointType_FootLeft].getY();
        float x_foot_right = joints[KinectPV2.JointType_FootRight].getX();
        float y_foot_right = joints[KinectPV2.JointType_FootRight].getY();
        int handState_Left = joints[KinectPV2.JointType_HandLeft].getState();
        for (int b=0; b < Balls.size(); b++) {
          Balls.get(b).checkCollision(x_Right, x_Left, y_Right, y_Left, x_foot_left, y_foot_left, x_foot_right, y_foot_right, JOINT_FOOT, JOINT_FOOT, handState_Right, handState_Left);
          //Balls.get(b).checkCollision(x, y);
        }
        /*
      mapping issue 1980 x 1080 --> w x h
         */
        //ellipse(x, y, 100, 100);

        //color col  = skeleton.getIndexColor();
        //fill(col);
        //stroke(col);
        //drawBody(joints);

        ////draw different color for each hand state
        //drawHandState(joints[KinectPV2.JointType_HandRight]);
        //drawHandState(joints[KinectPV2.JointType_HandLeft]);
      }
    }
    pushStyle();
    fill(0);
    rect(0, 0, 250, 150);
    rectMode(CENTER);
    rect(width/2, height/2, 250, 200);
    popStyle();
    fill(255);
    //text(frameRate, 50, 50);

    // game 
    text("Total Score: "+str(Score)+"\nBalls Punched : "+str(BallsPunched)+"\nBallsKicked : "+str(BallsKicked), 0, 0, width, height);
    pushStyle();
    textSize(20);
    text("Target Score: "+str(MaxScore)+"\nTarget Balls Punched : "+str(MaxBallsPunched)+"\nTarget Balls Kicked : "+str(MaxBallsKicked), 0, 0, 250, 150);
    popStyle();

    if (Score >= MaxScore && BallsPunched >= MaxBallsPunched && BallsKicked >= MaxBallsKicked) {
      CUR_MODE = CONG_MESSAGE;
    }

    // re-create balls
    if (frameCount % 90 == 0) {
      for (int i =0; i<random(30, 50); i++) {
        int size = int(random(20, 40));
        Balls.add(new Ball(random(width), random(height), size));
      }
    }

    // run
    for (int i=0; i < Balls.size(); i++) {
      Balls.get(i).move();
      Balls.get(i).display();
    }
    pushStyle();
    fill(0);
    rectMode(CENTER);
    rect(width/2, height/2, 250, 200);
    popStyle();
    pushStyle();
    fill(255);
    text("Total Score: "+str(Score)+"\nBalls Punched : "+str(BallsPunched)+"\nBallsKicked : "+str(BallsKicked), 0, 0, width, height);
    popStyle();
    // to constrain
    if (Balls.size() > 200) {
      Balls.remove(0);
    }
  }
  if (CUR_MODE == CONG_MESSAGE) {
    background(0);
    text("CONGRATULATIONS, YOU WOKE UP!  ANOTHER DAY TO WIN AHEAD OF YOU!", 0, 0, width, height);
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
  if (keyCode == ENTER) {
    print(myText);
  }
}