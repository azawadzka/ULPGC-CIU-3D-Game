

import processing.sound.*;

class Menu {
  PImage background, controllers_arduino, controllers_mouse;
  //PImage title;
  PFont fontTerrorTitle;
  PFont fontTerror;
  SoundFile intro;
  int tint;
  int options;
  boolean Controllers_display=false, credits_display=false;

  public Menu() {

    background = loadImage("resources/menu/background.jpg");
    //title = loadImage("resources/menu/title.png");
    intro = new SoundFile(Game.this, "resources/menu/intro theme.mp3");
    tint = 0;
    fontTerrorTitle = createFont("resources/fonts/youmurdererbb_reg.ttf", 150);
    fontTerror = createFont("resources/fonts/youmurdererbb_reg.ttf", 48);
    controllers_arduino = loadImage("resources/menu/controllers_arduino.jpg");
    controllers_mouse = loadImage("resources/menu/controllers_mouse.jpg");
  }

  public void display() {
    background.resize(width, height);
    tint(tint);
    image(background, 0, 0);
    //image(title, width/2-244, height/2-200);
    if (!intro.isPlaying()) intro.play();

    textAlign(CENTER);
    textFont(fontTerrorTitle);
    fill(255, 0, 0, tint);
    text("THE ROOM", width/2, height/2-200);
    textFont(fontTerror);
    text("Play", width/2, height/2+100);
    text("Controllers", width/2, height/2+150);
    text("Credits", width/2, height/2+200);
    textAlign(BASELINE);
    noStroke();
    switch (options) {
    case 0:
      triangle(width/2.2-20, height/2+80, width/2.2-20, height/2+100, width/2.2-10, height/2+90);
      break;
    case 1:
      triangle(width/2.2-60, height/2+130, width/2.2-60, height/2+150, width/2.2-50, height/2+140);
      break;
    case 2:
      triangle(width/2.2-40, height/2+180, width/2.2-40, height/2+200, width/2.2-30, height/2+190);
      break;
    }
    tint++;
    if (tint>255)tint=255;
    fill(255);
    if (Controllers_display) controllers();
    if (credits_display) credits();
  }

  public void pause() {
    textAlign(CENTER);
    if (control==0) {
      fill(0);
      rect(0, height/2, width, height/2);
      fill(255);
      text("PRESS 'C' TO CONTINUE", width/2, height-30);
    } else {
      fill(0);
      rect(0, 0, width, height/2);
      fill(255);
      text("PRESS 'P' TO CONTINUE", width/2, 30);
    }

    textAlign(BASELINE);
  }
  public void controllers() {
    background(0);
    controllers_arduino.resize(width, height/2);
    controllers_mouse.resize(width, height/2);
    if (control==0) {
      image(controllers_arduino, 0, 0);
      tint(255, 127);
      image(controllers_mouse, 0, height/2);
      noTint();
    } else {
      image(controllers_mouse, 0, height/2);
      tint(255, 127);
      image(controllers_arduino, 0, 0);
      noTint();
    }
  }

  public void credits() {
    background(0);
    textAlign(CENTER);
    String text = "MADE BY\n\nANNA ZAWADZKA\nALEXANDER SOREMBA\nISMAEL AARAB UMPIERREZ\nRUBEN GARCIA QUINTANA\n\n";
    if (control==0) {
      text += "PRESS LEFT BUTTON TO GO BACK TO THE MENU";
    } else {
      text += "PRESS ENTER TO GO BACK TO THE MENU";
    }
    text(text, width/2, 200);
    textAlign(BASELINE);
  }


  void set_controllers_display(boolean value) {
    Controllers_display=value;
  }
  void set_credits_display(boolean value) {
    credits_display=value;
  }
  boolean get_controllers_display() {
    return Controllers_display;
  }
  boolean get_credits_display() {
    return credits_display;
  }
}
