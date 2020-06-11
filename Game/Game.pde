import processing.video.*;

Capture cam;
Board board;
Room room;
Player player;
Camera camera;
Arrow arrow;
Menu menu;
Arduino arduino;

Serial arduino_Serial;
int control = 1;  //Para cambiar el control remoto.
int tint = 0;  // Opacity for transition scene

boolean debug = true;
boolean cam_on = false;
boolean status = true;  //which part is the player

BoardFactory boardFactory;
ObstacleFactory obstacleFactory;

int level = 0;

void setup() {
  size(1000, 700, P3D);
  obstacleFactory = new ObstacleFactory();
  boardFactory = new BoardFactory();
  menu = new Menu();
  next_level();
  smooth(8);
  //noCursor();
}

void draw() {  
  if (status) {
    menu.display();
  } else {
    updateRotation();

    hint(ENABLE_DEPTH_TEST);
    if (debug) debug_mode();

    directionalLight(100, 100, 100, 0, 1, 0); // dim lights
    camera.cam();
    player.move();
    room.display();
    if (room.check_ending_level()) {
      transition();
    } else {
      fill(255, 255, 255, 255);
      tint=0;
    }
    // board.debug_show_elements_on_board();

    hint(DISABLE_DEPTH_TEST);
    arrow.display();
    player.inventory.display();

    if (cam_on && cam.available()) {
      cam.read();
      image(cam, 0, 0, 320, 240);
    }
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
    print("game finished. You won");
    status=true;
    exit();
    return;
  }
  player = new Player(new Inventory(), board);
  room = new Room(board, player);
  camera = new Camera(player);
  arrow = new Arrow(player);
}

void mouseClicked() {
  if (true) {
    if (player.request_move()) {
      arrow.cancel_false_click();
    } else {
      arrow.set_false_click();
    }
  }
}

void keyPressed() {
  if (status) {

    if (keyCode==UP) {
      menu.options--;
      if (menu.options<0)menu.options=2;
    }

    if (keyCode==DOWN) {
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
      } catch (RuntimeException ex) {
        cam_on = false;
        println("Tried to activate camera but there are no devices available!");
      }
    }
    else cam.stop();
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
