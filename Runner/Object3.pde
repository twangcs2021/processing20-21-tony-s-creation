import processing.video.*;
import processing.sound.*;
import java.util.*;

public class juan
{
  
  private float x;
  private float y;
  
  private float imgWidth;
  private float imgHeight;
  
  private float leftBound, rightBound, upBound, downBound;
  
  private float speed;
  private float speedIncrease;
  
  private int yesum;
  private int updater;
  
  private int health;
  
  private boolean boss;
  
  public juan(float x, float y, float w, float h, int health, float speed, float speedIncrease) {
    this. x = x;
    this. y = y;
    this. speed = speed;
    this. speedIncrease = speedIncrease;
    this. imgWidth = w;
    this. imgHeight = h;
    this. health = health;
    boss = false;
    
    yesum = 0;
    updater = 0;
    
    leftBound = x - (imgWidth/2);
    rightBound = x + (imgWidth/2);
    upBound = y - (imgHeight/2);
    downBound = y + (imgHeight/2);
  }
  
    public juan(float x, float y, float w, float h, int health, float speed, float speedIncrease, boolean boss) {
    this. x = x;
    this. y = y;
    this. speed = speed;
    this. speedIncrease = speedIncrease;
    this. imgWidth = w;
    this. imgHeight = h;
    this. health = health;
    this. boss = boss;
    
    yesum = 0;
    updater = 0;
    
    leftBound = x - (imgWidth/2);
    rightBound = x + (imgWidth/2);
    upBound = y - (imgHeight/2);
    downBound = y + (imgHeight/2);
  }
  
  
  public void move(cheese yes) {
    float dx = x - yes.getX();
    float dy = y - yes.getY();
    float angle = atan2(dy, dx);
    float vx = speed * cos(angle);
    float vy = speed * sin(angle);
    
    if(rightBound < yes.getLeftBound() || leftBound > yes.getRightBound() || downBound < yes.getUpBound() || upBound > yes.getDownBound()) {
    
      
      x -= vx;
      y -= vy;
      
      leftBound -= vx;
      rightBound -= vx;
      upBound -= vy;
      downBound -= vy;
      
    }
  }
  
  public boolean boss() {
    return boss;
  }
  
  public void drawCows(float playerX)
  { 
    updater++;
    if(updater > 4) updater = 0;
    
    if(updater == 4) {
      yesum += 1;
      if(yesum > 19) yesum = 0;
    }
    
    if(x > playerX) {
      imageMode(CENTER);
      image(LcowFrames.get(yesum), x, y, imgWidth, imgHeight);
    }
    else {
      imageMode(CENTER);
      image(RcowFrames.get(yesum), x, y, imgWidth, imgHeight);
    }  
  }
  
  
  public boolean isDead() {
    if(health <= 0) {
      return true;
    }
    return false;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public int getHealth() {
    return health;
  }  
  
  public void changeHealth(int change) {
    health += change;
  }
  
  public void increaseSpeed() {
    speed += speedIncrease;
  }
  
  
  public float getLeftBound() {
    return leftBound;
  }
  public float getRightBound() {
    return rightBound;
  }
  public float getUpBound() {
    return upBound;
  }
  public float getDownBound() {
    return downBound;
  }  
}
