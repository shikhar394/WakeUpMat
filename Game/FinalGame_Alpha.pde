//Ball[] balls = new Ball[10];
import processing.sound.*;
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

ArrayList<Ball> Balls = new ArrayList<Ball>();
int Score;
SoundFile file;


void setup() 
{
  //size(1600, 900, P3D); //16:9
  fullScreen(P3D);
  noStroke();
  frameRate(30);
  ellipseMode(RADIUS);
  file = new SoundFile(this, "Twenty One Pilots - Stressed Out (Tomsize Remix).mp3");
  // create balls 
  for (int i =0; i<random(10); i++) {
    int size = int(random(20, 40));
    Balls.add(new Ball(random(width), random(height), size));
  }
  file.play();

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
}

void draw() 
{
  background(0);

  image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

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
      int handState_Left = joints[KinectPV2.JointType_HandLeft].getState();
      for (int b=0; b < Balls.size(); b++) {
        Balls.get(b).checkCollision(x_Right, x_Left, y_Right, y_Left, handState_Right, handState_Left);
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

  fill(255, 0, 0);
  text(frameRate, 50, 50);

  // game 
  text(str(Score), 10, 32);


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

  // to constrain
  if (Balls.size() > 200) {
    Balls.remove(0);
  }
}