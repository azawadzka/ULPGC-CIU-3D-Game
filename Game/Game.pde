import processing.video.*;
import processing.sound.*;

Capture cam;
Board board;
Room room;
Player player;
Monster monster;
Camera camera;
Arrow arrow;
Menu menu;
Arduino arduino;

SoundFile gameplay;
SoundFile steps;

private FX fx;

Serial arduino_Serial;
int control = 1;  //Para cambiar el control remoto.
int tint = 0;  // Opacity for transition scene

boolean debug = true;
boolean cam_on = false;
boolean status = true;  //which part is the player

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

  gameplay = new SoundFile(this, "resources/gameplay/background music.mp3");
  steps = new SoundFile(this, "resources/gameplay/steps.wav");

  menu = new Menu();
  next_level();
  smooth(8);
  //noCursor();
  fx = new FX(loadShader("resources/shader.glsl"));
}

void draw() {
  if (status) {
    menu.display();
  } else {
    if (!gameplay.isPlaying()) gameplay.play();
    updateRotation();

    hint(ENABLE_DEPTH_TEST);
    if (debug) debug_mode();

    directionalLight(100, 100, 100, 0, 1, 0); // dim lights
    camera.cam();
    if (!gameover) {
      player.move();
      monster.move();
      if (!monster.is_moving() || !player.is_moving()) { 
        if (check_collision_player_monster()) do_game_over(); // monster or player finished moving, check if monster colided with player
      }
    }
    room.display();

    if (gameover) {
      fx.apply_game_over_shader();
      if (fx.has_gameover_finished()) {
        print("Gameover finished\n");
        exit();
      }
    }

    if (!gameover) {
      if (room.check_ending_level()) {
        transition();
      } else {
        fill(255, 255, 255, 255);
        tint=0;
      }

      hint(DISABLE_DEPTH_TEST);
      arrow.display();
      player.inventory.display();
    }

    display_player_cam();
  }
}

private void display_player_cam() {
  if (cam_on && cam.available()) {
    cam.read();
    image(cam, 0, 0, 320, 240);
  }
}

public void debug_mode() {
  lights();
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
  arrow = new Arrow(player);
}

private void try_moving_player() {
  if (player.request_move()) {
    arrow.cancel_false_click();
    steps.play();
    if (!check_collision_player_monster()) monster.request_move();
  } else {
    arrow.set_false_click();
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
    }

    if (keyCode==DOWN && !menu.get_controllers_display() && !menu.get_credits_display()) {
      menu.options++;
      if (menu.options>2)menu.options=0;
    }

    if (keyCode==ENTER) {
      switch(menu.options) {

      case 0:
        status=false;
        menu.intro.stop();
        textFont(createFont("SansSerif", 16));
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
    if (key == 'l') next_level();

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
  }

  // J - joystick control
  if (key == 'j' || key == 'J') {
    try {
      arduino_Serial= new Serial(this, Serial.list()[0], 9600);
      arduino= new Arduino(arduino_Serial);
      control = 0;
    }
    catch (Exception e) {
      control = 1;
    }
  }

  // D - debug mode
  if (key == 'd' || key == 'D') {
    debug = !debug;
    if (debug) room.set_textures("DEBUG");
    else room.set_textures("NORMAL");
  }

  // C - video camera
  if (key == 'c' || key == 'C') {
    cam_on = !cam_on;
    if (cam_on) {
      try {
        if (cam == null) cam = new Capture(this, 640, 480);
        cam.start();
      } 
      catch (RuntimeException ex) {
        cam_on = false;
        println("Tried to activate camera but there are no devices available!");
      }
    } else cam.stop();
  }
}

void transition() {
  fill(0, 0, 0, tint);
  rect(0, 0, width, height);
  tint+=4;
  if (tint >255) {
    fill(255, 255, 255, 255);
    next_level();
    tint=0;
  }
}

void serialEvent(Serial arduino_Serial) {
  arduino.serial_Event_Manager(arduino_Serial);
}
