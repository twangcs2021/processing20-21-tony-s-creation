import processing.video.*;
import processing.sound.*;
import java.util.*;

public class bean
{
  private float xPos;
  private float yPos;
  
  private float vx;
  private float vy;
  
  public bean(float x, float y, float vx, float vy)
  {
    xPos = x;
    yPos = y;
    
    this.vx = vx;
    this.vy = vy;
  }
  
  public void moveAndDraw() {
    xPos += vx;
    yPos += vy;
    
    fill(0);
    ellipse(xPos, yPos, 10, 10);
    
  }  
  
  public float getX() {
    return xPos;
  }
  
  public float getY() {
    return yPos;
  }
  
}
