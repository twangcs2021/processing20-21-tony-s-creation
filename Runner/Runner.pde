// to do
//make boss at every 100 points
//make UI/restart system

import processing.video.*;
import processing.sound.*;
import java.util.*;

//basic shid
Random rand = new Random();
Capture video;
SoundFile song;
SoundFile wiiSong;
SoundFile beat;

boolean bPressed;
boolean pPressed;
boolean rPressed;

int w, h;

//phase shid
int phase;

PImage title;
PImage instructions;
PImage gameEnd;



//player shid
PImage monke;
cheese yes;

int imgWidth;
int imgHeight;

//bullet shid
float bulletSpeed;
ArrayList<bean> bullets = new ArrayList<bean>();

//enemy shid
ArrayList<juan> enemies = new ArrayList<juan>();
public ArrayList<PImage> RcowFrames = new ArrayList<PImage>();
public ArrayList<PImage> LcowFrames = new ArrayList<PImage>();

int eWidth, eHeight;
float eSpeed, eSpeedIncrease;
int eHealth;

float bossSpeed, bossSpeedIncrease;
int bossHealth;

boolean bossTime, bossActivated;

int points;
boolean playerEnemyCollision;
boolean bulletEnemyCollision;





void captureEvent(Capture video) {
  video.read();
}

void setup()
{
  w = displayWidth;
  h = displayHeight;
  fullScreen();
  
  phase = -1;
  
  String path = sketchPath("music/COW.mp3");
  String path2 = sketchPath("music/wii.mp3");
  String path3 = sketchPath("music/beat.mp3");
  
  song = new SoundFile(this, path); 
  wiiSong = new SoundFile(this, path2);
  beat = new SoundFile(this, path3);
  
  video = new Capture(this, Capture.list()[0]);
  
  title = loadImage("screens/TitleScreen.png");
  instructions = loadImage("screens/Instructions.png");
  gameEnd = loadImage("screens/GameEnd.png");
  
  bPressed = false;
  pPressed = false;
  rPressed = false;
  
  for(int i = 1; i <= 20; i++)
  {
    PImage stinkerR = loadImage("RcowFrames/cow" + i + ".png");
    PImage cowR = stinkerR.get(635, 240, 650, 700);
    
    RcowFrames.add(cowR);
    
    PImage stinkerL = loadImage("LcowFrames/cow" + i + ".png");
    PImage cowL = stinkerL.get(635, 240, 650, 700);
    
    LcowFrames.add(cowL);
  }
  
  imgWidth = 100;
  imgHeight = 100;
  
  bulletSpeed = 50;
  
  eWidth = 650/5;
  eHeight = 700/5;
  
  eSpeed = 3;
  eSpeedIncrease = 0.01;
  eHealth = 1;
  
  bossSpeed = 5;
  bossHealth = 50;
  bossSpeedIncrease = 0.01;
  
  bossTime = false;
  bossActivated = false;
  
  beat.play();
}

boolean firstTimeStartingVideo = true;

float startTime;
float elapsedTime;

float songStart;
float songTime;

int invincTimer;
int elapsedTimeSinceInvinc;
boolean noMore = false;
boolean noMore2 = false;
int poop = 1;

boolean broMoment= true;

void draw()
{
  frameRate(60);
  background(126);
  
  if(phase == -1) {
    imageMode(CENTER);
    image(title, w/2, h/2, w, h);
    
    
    
    if(bPressed)
    {
      bPressed = false;
      phase = 0;
    }
    

  }
  else if (phase == 0) {
    imageMode(CENTER);
    image(instructions, w/2, h/2, w, h);
    
    if(bPressed)
    {
      bPressed = false;
      phase = 1;
    }
    if(pPressed) {
      beat.stop();
      int num = rand.nextInt(3);
      
      switch(num) {
        case 0:
          monke = loadImage("characters/mantisToboggan.jpg");
          break;
        case 1:
          monke = loadImage("characters/ongoGablogian.jpg");
          break;
        case 2:
          monke = loadImage("characters/couch.jpeg");
          break;
        default:
          monke = loadImage("characters/spiderman.jpg");
          break;
      }  
      
      
      
      
      yes = new cheese(monke, imgWidth, imgHeight, 10, 12);
      
      phase = 2;
      startTime = second()+60*(minute()+60*(hour()+24*day()));
      songStart = second()+60*(minute()+60*(hour()+24*day()));
      song.play();
    }
    
  }
  else if(phase == 1) {
    if(firstTimeStartingVideo) {
      video.start();
      firstTimeStartingVideo = false;
    }

    
    imageMode(CENTER);
    image(video, w/2, h/2);
    centerRectangle();
    
    if(bPressed)
    {
      beat.stop();
      video.stop();
      monke = screenshot();
      yes = new cheese(monke, imgWidth, imgHeight, 10, 12);
      
      phase = 2;
      startTime = second()+60*(minute()+60*(hour()+24*day()));
      song.play();
    }
  }
  else if (phase == 2) {
    elapsedTime = (second()+60*(minute()+60*(hour()+24*day()))) - startTime;
    songTime = (second()+60*(minute()+60*(hour()+24*day()))) - songStart;
    
    if(songTime >= 244) {
      song.loop();
      songStart = second()+60*(minute()+60*(hour()+24*day()));
    }
    
    if(yes.invinc()) elapsedTimeSinceInvinc = (second()+60*(minute()+60*(hour()+24*day()))) - invincTimer;
    
    if(elapsedTimeSinceInvinc >= 3) yes.setInvinc(false);

    
    if(points % 50 == 0 && points != 0) bossTime = true;
    
    if(bossTime && !bossActivated) {  
      enemies.clear();
      
      enemies.add(new juan(w/2, -2 * eHeight, eWidth * 3, eHeight * 3, bossHealth, bossSpeed, 0, true) );
      
      bossActivated = true;
    }

    if(!bossTime) {
      if(elapsedTime % 10 == 0) {
        if(!noMore) {
          eSpeed += 0.003;
          eSpeedIncrease += 0.001;
          
          cowSpawner(eHealth, eSpeed, eSpeedIncrease);
  
        }
        noMore = true;
      }
      else {
        noMore = false;
      }
      
  
      
      if(enemies.size() == 0) {
        cowSpawner(eHealth, eSpeed, eSpeedIncrease);
      }
    }
    //for every bullet, make it moveAndDraw. If out of bounds, remove from list. 
    for(int i = 0; i < bullets.size(); i++)
    {
      (bullets.get(i)).moveAndDraw();

      if( (bullets.get(i)).getX() > w *2 || (bullets.get(i)).getX() < -w || (bullets.get(i)).getY() < -h || (bullets.get(i)).getX() > h * 2) {
        bullets.remove(i);
      }
    }
    
    playerEnemyCollision = false;
    
   
    for(int i = 0; i < enemies.size(); i++) {
      bulletEnemyCollision = false;
      
      juan heck = enemies.get(i);
      
      if(!playerEnemyCollision) {
        yes.collisionCheck(heck);
        
        if(heck.getRightBound() < yes.getLeftBound() || 
           heck.getLeftBound() > yes.getRightBound() || 
           heck.getDownBound() < yes.getUpBound() || 
           heck.getUpBound() > yes.getDownBound()){
          playerEnemyCollision = false;
        }
        else {
          playerEnemyCollision = true;
        }
      }
      
      heck.increaseSpeed();
      heck.move(yes);
      heck.drawCows(yes.getX());
      
      for(int j = 0; j < bullets.size(); j++) {
        
        if( between(heck.getLeftBound(), (bullets.get(j)).getX(), heck.getRightBound()) && 
            between(heck.getUpBound(), (bullets.get(j)).getY(), heck.getDownBound() )) {
          bullets.remove(j);
          bulletEnemyCollision = true;
        }
      }
      
      boolean leatFingie = true;
      if(playerEnemyCollision) {
        if(!yes.invinc()) {
          yes.changeHealth(-1);
          yes.setInvinc(true);
          
          invincTimer = second()+60*(minute()+60*(hour()+24*day()));
        }
        
        if(!bossTime) {
          enemies.remove(i);
          leatFingie = false;
        }
      }
      if(leatFingie) {
        if(bulletEnemyCollision) {
          (enemies.get(i)).changeHealth(-1);
          
        }  
        
        if(heck.isDead()) {
          enemies.remove(i);
          
          
          if(!bossTime) {
            points++;
            eSpeed += 0.003;
            eSpeedIncrease += 0.001;
            
            cowSpawner(eHealth, eSpeed, eSpeedIncrease);
          }
          
          if(heck.boss()) {
            bossActivated = false;
            bossTime = false;
            points += 5;
            
            bossHealth += 50;
            bossSpeed *= 1.5;
            bossSpeedIncrease += 0.02;
            
            if(bossSpeed > 8) bossSpeed = 8;
            
          }
        }
      }
      if(yes.isDead()) {
        phase = 3;
        wiiSong.play();
      }
    }
    
    //move player according to inputs, draw player at new location
    yes.moveAndDraw();
    
    displayText("Points: " + points, 100, h - 60);
    displayPlayerHealth();
  }
  else if (phase == 3) {
    song.stop();
    points = 0;
    
    eSpeed = 3;
    eSpeedIncrease = 0.01;
    eHealth = 1;
    
    bossSpeed = 5;
    bossHealth = 50;
    bossSpeedIncrease = 0.01;
    
    
    bossTime = false;
    bossActivated = false;
    
    
    if(broMoment) {
      bullets.clear();
      enemies.clear();
      
      broMoment = false;
    }
    
    imageMode(CENTER);
    image(gameEnd, w/2, h/2, w, h);
    
    if(rPressed) {
      rPressed = false;
      wiiSong.stop();
      phase = 0;
    }
  }
}

public void cowSpawner(int health, float speed, float speedIncrease) {
  if(!bossTime) {
    int x = 0;
    int y = 0;
    
    int num = rand.nextInt(4);
    
    switch(num) {
      //random enemy from the top
      case 0:
        y = -eHeight/2;
        x = rand.nextInt(w);
        break;
        
      //random enemy from the left
      case 1:
        x = -eWidth/2;
        y = rand.nextInt(h);
        break;
        
      //random enemy from the right
      case 2:
        x = w + eWidth/2;
        y = rand.nextInt(h);
        break;
        
      //random enemy from the bottom
      case 3:
        y = h + eHeight/2;
        x = rand.nextInt(w);
        break;
    }
    
    enemies.add(new juan(x, y, eWidth, eHeight, health, speed, speedIncrease));
  }
  else
  {
    System.out.println("Points: " + points);
    println("ElapsedTime: " + elapsedTime);
    println();
  }
}

public void displayText(String s, int x, int y) {
  PFont mono = createFont("fonts/andalemo.ttf", 32);
  
  textFont(mono);
  fill(0, 102, 153);
  text(s, x, y);
}


public boolean between(float lowerBound, float x, float upperBound) {
  if( (lowerBound < x) && (x < upperBound) ) {
    return true;
  }
  return false;
}

void mousePressed() {
  if(phase == 2)
  {
    float dx = mouseX - yes.getX();
    float dy = mouseY - yes.getY();
    float angle = atan2(dy, dx);
    float vx = bulletSpeed * cos(angle);
    float vy = bulletSpeed * sin(angle);
    
    bullets.add(new bean(yes.getX(), yes.getY(), vx, vy));
  }
}  

void keyPressed() {
  if(key == 'b' || key == 'B') bPressed = true;
  if(key == 'p' || key == 'P') pPressed = true;
  if(key == 'r' || key == 'R') rPressed = true;
  
  if(phase == 2)
  {
    yes.setMove(key, true);
  }
}
 
void keyReleased() {
  if(key == 'b' || key == 'B') bPressed = false;
  if(key == 'p' || key == 'P') pPressed = false;
  if(key == 'r' || key == 'R') rPressed = false;

  
  if(phase == 2)
  {
    yes.setMove(key, false);
  }
}



PImage screenshot() {
  saveFrame("poop.jpg");  
  
  PImage uhOh = loadImage("poop.jpg");
  PImage stinky = uhOh.get(w/2 - imgWidth/2 , h/2 - imgHeight/2, imgWidth, imgHeight);
  
  return stinky;
}

void deleteImage(String name) {
  //deleting this file
  String fileName = sketchPath(name);
  File file = sketchFile(fileName);
  
  System.gc();
  file.delete();
}

void displayPlayerHealth() {
  PFont mono = createFont("fonts/andalemo.ttf", 32);
  
  textFont(mono);
  fill(0, 102, 153);
  text("Health: " + yes.getHealth(), w - 300, h - 60);
}

void centerRectangle() {
  stroke(0);
  strokeWeight(5);
  noFill();
  rect(w/2 - imgWidth/2 , h/2 - imgHeight/2, imgWidth, imgHeight);
}
