import processing.video.*;
import processing.serial.*;
Capture cam;

Board board;
Room room;
Player player;
Camera camera;
Arrow arrow;
int tint = 0;

//COSAS PARA LECTOR SERIAL
int [] buffer = new int[3] ;
public int control = 1;  //Para cambiar el control remoto.
public Serial arduinoSerial; //Conexion al Serial

BoardFactory boardFactory;
ObstacleFactory obstacleFactory;

int level = 0;
boolean cam_on = false;

void setup() {
  size(1000, 700, P3D);
  smooth(8);
  
  obstacleFactory = new ObstacleFactory();
  boardFactory = new BoardFactory();
  
  next_level();
  //noCursor();    
}

void draw() {  
  updateRotation();

  hint(ENABLE_DEPTH_TEST); 
  //directionalLight(100, 100, 100, 0, 1, 0); // dim lights
  lights();
  camera.cam();
  player.move();
  room.display();
  check_if_next_level();
  
  // board.debug_show_elements_on_board();

  hint(DISABLE_DEPTH_TEST);
  arrow.display();
  player.inventory.display();

  if (cam_on && cam.available()) {
    cam.read();
    image(cam, 0, 0, 320, 240);
  }
}

void check_if_next_level() {
  if (room.check_ending_level()) {
    transition();
  } else {
    fill(255, 255, 255, 255);
    tint = 0;
  }
}

void next_level() {
  level++;
  board = boardFactory.create_board_for_level(level);
  if (board == null) {
    print("game finished. You won");
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
  if (key == 'l') next_level();

  // F - pick item
  if (room.getItem() != null && (key == 'F' || key == 'f') && room.getItem().getPickable()) {
    Obstacle item = room.getItem();
    item.setPickable(false);
    player.inventory.addItem(item);
    board.free_element(room.item_p, room.item_r);
  }

  // B - ???
  if ((key == 'B' || key == 'b') && room.player_can_unlock()) { //room.getLockedObject() != null &&  && room.getLockedObject().isUnlockable()
    board.free_element(room.item_p, room.item_r);    
    player.inventory.removeItem(room.getItem());
    player.inventory.display();
  }
  
  // J - joystick control
  if (key == 'j' || key == 'J') {
    try {
      arduinoSerial= new Serial(this, Serial.list()[0], 9600);
      control = 0;
    } catch (Exception e) {
      control = 1;
    }
  }
  
  // M - mouse control
  if (key == 'm' || key == 'M') {
    control = 1;
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
  tint += 4;
  if (tint > 255) {
    fill(255, 255, 255, 255);
    next_level();
    tint = 0;
  }
}


/*
 * Serial port events
 */
 
void serialEvent(Serial arduinoSerial) {
  arduinoSerial.bufferUntil('\n');
  String aux = arduinoSerial.readStringUntil('\n'); //es necesario crear una variable auxiliar, lo explico en otro momento xD
  if (aux != null) buffer = int(split(aux, "-"));
  joystick_curvature = buffer[0];
  if (buffer[1] == 1) rightButtonClicked();
  if (buffer[2] == 1) leftButtonClicked();
}

void rightButtonClicked() {
  if (player.request_move()) {
    arrow.cancel_false_click();
  } else {
    arrow.set_false_click();
  }
}

void leftButtonClicked() {
  if (room.getItem() != null && room.getItem().getPickable()) {

    Obstacle item = room.getItem();
    item.setPickable(false);
    player.inventory.addItem(item);
    board.free_element(room.item_p, room.item_r);
  }

  if (room.player_can_unlock()) { //room.getLockedObject() != null &&  && room.getLockedObject().isUnlockable()
    board.free_element(room.item_p, room.item_r);    
    player.inventory.removeItem(room.getItem());
    player.inventory.display();
  }
}
