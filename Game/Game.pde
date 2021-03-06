import processing.video.*;
import processing.sound.*;

PGraphics game_layer;
PGraphics top_layer;
Capture cam;
Board board;
Room room;
Player player;
Monster monster;
Camera camera;
Torch torch;
Arrow arrow;
Menu menu;
Arduino arduino;

SoundFile gameplay;
SoundFile steps;
SoundFile game_over_song;

private FX fx;

Serial arduino_Serial;
int control = 1;  //Para cambiar el control remoto.
int tint = 0;  // Opacity for transition scene

boolean debug = false;
boolean cam_on = false;
boolean status = true;  //which part is the player
boolean game_over_screen = false;
boolean pause = false;

BoardFactory boardFactory;
ObstacleFactory obstacleFactory;
MonsterFactory monsterFactory;

int level = 0;

boolean gameover = false;

void setup() {
  surface.setTitle("The Room");
  size(1000, 700, P3D);
  
  obstacleFactory = new ObstacleFactory();
  boardFactory = new BoardFactory();
  monsterFactory = new MonsterFactory();

  game_layer = createGraphics(width, height, P3D);
  top_layer = createGraphics(width, height);

  gameplay = new SoundFile(this, "resources/gameplay/background music.mp3");
  steps = new SoundFile(this, "resources/gameplay/steps.wav");
  game_over_song = new SoundFile(this, "resources/gameplay/game_over.mp3");

  menu = new Menu();
  next_level();
  smooth(8);
  //noCursor();
  fx = new FX(loadShader("resources/shader.glsl"));
}

void draw() {

  if (game_over_screen) {
    fx.gameover_screen();
  } else if (status) {
    menu.display();
  } else {

    if (!pause) {
      if (!gameplay.isPlaying()) gameplay.play();
      updateRotation();

      game_layer.beginDraw();
      game_layer.clear();
      top_layer.beginDraw();
      top_layer.clear();

      if (debug) debug_mode();
      hint(ENABLE_DEPTH_TEST);
      game_layer.ambientLight(20, 20, 20); // dim lights
      torch.light();
      camera.cam();
      if (!gameover) {
        player.move();
        monster.move();
        if (!monster.is_moving() || !player.is_moving()) { 
          if (check_collision_player_monster()) do_game_over(); // monster or player finished moving, check if monster colided with player
        }

      }
      room.display();


      if (!gameover) {
        if (room.check_ending_level()) {
          transition();
        } else {
          game_layer.fill(255, 255, 255, 255);
          tint = 0;
        }

        hint(DISABLE_DEPTH_TEST);
        arrow.display();
        player.inventory.display();
      }

      display_player_cam();

      game_layer.endDraw();
      top_layer.endDraw();
      image(game_layer, 0, 0, width, height);
      image(top_layer, 0, 0, width, height);
    } else {

      menu.controllers();
      menu.pause();
    }
  }

  if (gameover) {
    fx.apply_game_over_shader();
    gameplay.stop();
    if (!game_over_song.isPlaying()) game_over_song.play();
    if (fx.has_gameover_finished()) {
      game_over_screen = true;
      gameover = false;
      resetShader();
    }
  }
}

private void display_player_cam() {
  if (cam_on && cam.available()) {
    cam.read();
    top_layer.image(cam, 0, 0, 320, 240);
  }
}

public void debug_mode() {
  game_layer.lights();
  //board.debug_show_elements_on_board();
}

void next_level() {
  level++;
  board = boardFactory.create_board_for_level(level);
  if (board == null) {
    print("Game finished. You won\n");
    exit();
    return;
  }
  player = new Player(new Inventory(), board);
  monster = monsterFactory.create_monster_for_level(level, board);
  room = new Room(board, player, monster);
  camera = new Camera(player);
  torch = new Torch(player);
  arrow = new Arrow(player);
}

private void try_moving_player() {
  if (!status && !game_over_screen && !pause) {
    if (player.request_move()) {
      arrow.cancel_false_click();
      steps.play();
      if (!check_collision_player_monster()) monster.request_move();
    } else {
      arrow.set_false_click();
    }
  }
}

private boolean check_collision_player_monster() {
  return (player.getR() == monster.getR() && player.getP() == monster.getP());
}

private void do_game_over() {
  print("The monster got you. You lose\n");
  gameover = true;
  fx.start_game_over_shader();
}

void mouseClicked() {
  try_moving_player();
}

void keyPressed() {
  if (status) {

    if (keyCode==UP && !menu.get_controllers_display() && !menu.get_credits_display()) {
      menu.options--;
      if (menu.options<0)menu.options=2;
    } else if (keyCode==UP && menu.get_controllers_display()) {
      if (control==1) {
        control=0;
        start_arduino();
      }
    }

    if (keyCode==DOWN && !menu.get_controllers_display() && !menu.get_credits_display()) {
      menu.options++;
      if (menu.options>2)menu.options=0;
    } else if (keyCode==DOWN && menu.get_controllers_display()) {
      if (control==0) {
        control=1;
      }
    }

    if (keyCode==ENTER) {
      switch(menu.options) {

      case 0:
        status=false;
        menu.intro.stop();
        textFont(createFont("SansSerif", 16));
        tint(255);
        break;
      case 1:
        menu.set_controllers_display(!menu.get_controllers_display());
        menu.set_credits_display(false);
        break;
      case 2:
        menu.set_controllers_display(false);
        menu.set_credits_display(!menu.get_credits_display());
        break;
      }
    }
  } else {
    if (!pause) {
      //if (key == 'l') next_level();

      if (room.getItem() != null && (key == 'F' || key == 'f') && room.getItem().getPickable()) {
        Obstacle item = room.getItem();
        item.setPickable(false);
        player.inventory.addItem(item);
        board.remove_from_board(room.item_p, room.item_r);
      }

      if ((key == 'B' || key == 'b') && room.player_can_unlock()) { //room.getLockedObject() != null &&  && room.getLockedObject().isUnlockable()
        board.remove_from_board(room.item_p, room.item_r);
        player.inventory.removeItem(room.getItem());
        player.inventory.display();
      }

      if (key == 'P' || key == 'p') pause = true;
    } else {
      if (key == 'P' || key == 'p') pause = false;
      if (keyCode==DOWN) {
        if (control==0) {
          control=1;
        }
      }
      if (keyCode==UP) {
        if (control==1) {
          control=0;
          start_arduino();
        }
      }
      
      if(key == 'B' || key == 'b')reset();
    }
  }

  // D - debug mode
  /*if (key == 'd' || key == 'D') {
    debug = !debug;
    if (debug) room.set_textures("DEBUG");
    else room.set_textures("NORMAL");
  }*/

  // C - video camera
  /*if (key == 'c' || key == 'C') {
    cam_on = !cam_on;
    if (cam_on) {
      try {
        if (cam == null) cam = new Capture(this, 640, 480);
        cam.start();
        println("Camera on");
      }
      catch (RuntimeException ex) {
        cam_on = false;
        println("Tried to activate camera but there are no devices available!");
      }
    } else {
      cam.stop();
      println("Camera off");
    }
  }*/
}

void transition() {
  game_layer.fill(0, 0, 0, tint);
  game_layer.rect(0, 0, width, height);
  tint += 4;
  if (tint > 255) {
    game_layer.fill(255, 255, 255, 255);
    next_level();
    tint = 0;
  }
}

void serialEvent(Serial arduino_Serial) {
  arduino.serial_Event_Manager(arduino_Serial);
}

void start_arduino() {
  if (control==0 && arduino== null) {
    try {
      arduino_Serial= new Serial(this, Serial.list()[0], 9600);
      arduino= new Arduino(arduino_Serial);
      control = 0;
    }
    catch (Exception e) {
      control = 1;
    }
  }
}



void reset() {
  status = true;
  obstacleFactory = new ObstacleFactory();
  boardFactory = new BoardFactory();
  monsterFactory = new MonsterFactory();
  menu = new Menu();
  level = 0;
  next_level();
  gameplay.stop();
  steps.stop();
  game_over_song.stop();
  pause = false;
  gameover = false;
  game_over_screen = false;
}
