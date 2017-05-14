class Ball {
  boolean COLLISION = false; 
  float XPos, YPos, XSpd, YSpd, size;
  color c;
  Ball(float _x, float _y, float _size) {
    XPos = _x;
    YPos = _y;
    size = _size;
    XSpd = random(-1, 1);
    YSpd = random(-1, 1);
    c = color(255);
  }
  void display()
  {
    fill(c);
    ellipse(XPos, YPos, size, size);
  }
  void move() {
    XPos += XSpd;
    YPos += YSpd;
  }
          //Balls.get(b).checkCollision(x_Right, x_Left, y_Right, y_Left handState_Right, handState_Left)
  void checkCollision(float x_Right, float x_Left, float y_Right, float y_Left, int state_Right, int state_Left) {
    float distance_Right = dist(XPos, YPos, x_Right, y_Right);
    float distance_Left = dist(XPos, YPos, x_Left, y_Left);
    if (distance_Right < size + 50 || distance_Left < size + 50) {
      if (COLLISION == false)
        Score = Score + 1;
        c = color(random(255), random(255), random(255));
      COLLISION = true;
      //c = color(random(255), random(255), random(255));
      if (state_Right == 3 || state_Left == 3) {
        c = color(random(255), random(255), random(255));
        XSpd = random(-10, 10);
        YSpd = random(-10, 10);
      }
    } else {
      //c = color(255);
    }
  }
}