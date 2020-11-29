import processing.video.*;
import processing.sound.*;
import java.util.*;

public class cheese
{
  private PImage img;
  private float imgWidth, imgHeight;
  
  private float leftBound, rightBound, upBound, downBound;
  
  private float posX = 500;
  private float posY = 500;
  private float speed;
  
  private boolean isUp, isRight, isLeft, isDown;
  private boolean canUp, canRight, canLeft, canDown;
  
  private int health;
  
  private boolean invinc;
  
  public cheese(PImage poop, int chungus, int cheese, int goof, float speed)
  {
    img = poop;
    imgWidth = chungus;
    imgHeight = cheese;
    this. speed = speed;
    
    health = goof;
    
    int thicky = 5;
    
    leftBound = posX - (imgWidth/2 + thicky);
    rightBound = posX + (imgWidth/2 + thicky);
    upBound = posY - (imgHeight/2 + thicky);
    downBound = posY + (imgHeight/2 + thicky);
    
    canUp = true;
    canRight = true;
    canLeft = true;
    canDown = true;
    
    invinc = false;
  }
  
  public boolean setMove(char k, boolean b) {
    switch (k) {
      case 'w':
        return isUp = b;
      case 's':
        return isDown = b;
      case 'a':
        return isLeft = b;
      case 'd':
        return isRight = b;

      default:
        return b;
    }

  }
  
  public boolean collisionCheck(juan heck) {
    boolean collision = false;
    int safeFactor = 15;
    
    if(!( 
      between(heck.getRightBound() - safeFactor, leftBound, heck.getRightBound()) && 
      ( between(heck.getUpBound(), upBound, heck.getDownBound()) || between(heck.getUpBound(), downBound, heck.getDownBound()) ) 
      )){
        canLeft = true;
    }
    else {
      canLeft = false;
      collision = true;
    }

    if(!( 
      between(heck.getLeftBound(), rightBound, heck.getLeftBound() + safeFactor) && 
      ( between(heck.getUpBound(), upBound, heck.getDownBound()) || between(heck.getUpBound(), downBound, heck.getDownBound()) ) 
      )){
        canRight = true;
    }    
    else {
      canRight = false;
      collision = true;
    }
    
    if(!( 
      between(heck.getUpBound(), downBound, heck.getUpBound() + safeFactor) && 
      ( between(heck.getLeftBound(), leftBound, heck.getRightBound()) || between(heck.getLeftBound(), rightBound, heck.getRightBound()) ) 
      )){  
        canDown = true;
    }
    else {
      canDown = false;
      collision = true;
    }
    
    if(!( 
      between(heck.getDownBound() - safeFactor, upBound, heck.getDownBound()) && 
      ( between(heck.getLeftBound(), leftBound, heck.getRightBound()) || between(heck.getLeftBound(), rightBound, heck.getRightBound()) ) 
      )){  
        canUp = true;  
    }
    else {
      canUp = false;
      collision = true;
    }
    
    
    return collision;
  }
  
  

  
  public void moveAndDraw() {
    
    if (isLeft && (leftBound >= 0) && canLeft) {
      this.left();
    }
    if (isRight && (rightBound <= w) && canRight) {
      this.right();
    }
    if (isDown && (downBound <= h) && canDown) {
      this.down();
    }
    if (isUp && (upBound >= 0) && canUp) { 
      this.up();  
    }
    
    imageMode(CENTER);
    image(img, posX, posY, imgWidth, imgHeight );
  }
  
  public void setInvinc(boolean s) {
    invinc  = s;
  }
  
  public boolean invinc() {
    return invinc;
  }
  
  public boolean between(float lowerBound, float x, float upperBound) {
    if( (lowerBound < x) && (x < upperBound) ) {
      return true;
    }
    return false;
  }
  
  public void up() {
    posY -= speed;
    upBound -= speed;
    downBound -= speed;
  }  
  
  public void left() {
    posX -= speed;
    leftBound -= speed;
    rightBound -= speed;
  }  
  public void down() {
    posY += speed;
    upBound += speed;
    downBound += speed;
  }  
  
  public void right() {
    posX += speed;
    leftBound += speed;
    rightBound += speed;
  }  
  
  public boolean isDead() {
    if(health <= 0) {
      return true;
    }
    return false;
  }
  
  public boolean isUp() {
    return isUp;
  }
  public boolean isDown() {
    return isDown;
  }
  public boolean isLeft() {
    return isLeft;
  }
  public boolean isRight() {
    return isRight;
  }
  
  public PImage getImage()
  {
    return img;   
  }
  
  
  public float getX() {
    return posX;
  }
  public float getY() {
    return posY;
  }  
  
  public int getHealth() {
    return health;
  }
  
  public void changeHealth(int change) {
    health += change;
  }
  
  public float getImgWidth() {
    return imgWidth;
  }
  public float getImgHeight() {
    return imgHeight;
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
