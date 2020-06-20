/*
import ddf.minim.*;
 import ddf.minim.analysis.*;
 import ddf.minim.effects.*;
 import ddf.minim.signals.*;
 import ddf.minim.spi.*;
 import ddf.minim.ugens.*;*/

import processing.sound.*;

class Menu {
  PImage background;
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
  }

  public void display() {
    background.resize(width, height);
    tint(tint);
    image(background, 0, 0);
    //image(title, width/2-244, height/2-200);
    if (!intro.isPlaying()) intro.play();

    textAlign(CENTER);
    textFont(fontTerrorTitle);
    fill(255, 0, 0);
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


  public void controllers() {
    background(0);
    textAlign(CENTER);
    if (control==0) {
      text("TEST\nPRESS LEFT BUTTON TO BACK TO THE MENU", width/2, height/2);
    } else {
      text("TEST\nPRESS ENTER TO BACK TO THE MENU", width/2, height/2);
    }

    textAlign(BASELINE);
  }

  public void credits() {
    background(0);
    textAlign(CENTER);
    if (control==0) {
      text("MADE BY\nANNA ZAWADZKA\nALEXANDER SOREMBA\nISMAEL AARAB UMPIERREZ"+
        "\nruben Garcia Quintana\nPRESS LEFT BUTTON TO BACK TO THE MENU", width/2, 200);
    } else {
      text("MADE BY\nANNA ZAWADZKA\nALEXANDER SOREMBA\nISMAEL AARAB UMPIERREZ"+
        "\nruben Garcia Quintana\nPRESS ENTER TO BACK TO THE MENU", width/2, 200);
    }

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
