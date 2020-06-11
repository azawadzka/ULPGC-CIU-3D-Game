import processing.video.*;
import processing.serial.*;

Board board;
Room room;
Player player;
Camera camera;
Arrow arrow;

BoardFactory boardFactory;
ObstacleFactory obstacleFactory;
int tint;
int level = 0;

//COSAS PARA LECTOR SERIAL
int [] buffer= new int[3] ;
public int control=0;  //Para cambiar el control remoto.
public Serial arduinoSerial; //Conexion al Serial
int joystickX=500; //rotación de la camara

void setup() {
  size(1000, 700, P3D);
  obstacleFactory = new ObstacleFactory();
  boardFactory = new BoardFactory();
  next_level();
  smooth(8);
  //noCursor();

  try {
    arduinoSerial= new Serial(this, Serial.list()[0], 9600 );
  }
  catch(Exception e) {
    control=1;
  }
}

void draw() {  
  updateRotation();

  hint(ENABLE_DEPTH_TEST); 
  //directionalLight(100, 100, 100, 0, 1, 0); // dim lights
  lights();
  camera.cam();
  player.move();
  room.display();
  if (room.check_ending_level()) {
    next_level();
  }
  // board.debug_show_elements_on_board();

  hint(DISABLE_DEPTH_TEST);
  arrow.display();
  player.inventory.display();
  
  //PARA PRESENTACION
  /*if (cam.available()) {
   cam.read();
   image(cam, 0, 0, 320, 240);
   }*/
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

  if (player.request_move()) {
    arrow.cancel_false_click();
  } else {
    arrow.set_false_click();
  }
}

void keyPressed() {
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



void transicion() {
  fill(0, 0, 0, tint);
  rect(0, 0, width, height);
  tint+=4;
  if (tint >255) {
    fill(255, 255, 255, 255);
    next_level();
    tint = 0;
  }
}




/*
*  Eventos del Serial
 */
void serialEvent(Serial arduinoSerial) {
  arduinoSerial.bufferUntil('\n');
  String aux=arduinoSerial.readStringUntil('\n'); //es necesario crear una variable auxiliar, lo explico en otro momento xD
  if (aux != null)buffer= int(split(aux, "-"));
  angulo=buffer[0];
  if (buffer[1]==1)rightButtonClicked();
  if (buffer[2]==1)leftButtonClicked();
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

  if (  room.player_can_unlock()) { //room.getLockedObject() != null &&  && room.getLockedObject().isUnlockable()
    board.free_element(room.item_p, room.item_r);    
    player.inventory.removeItem(room.getItem());
    player.inventory.display();
  }
}


//FIN EVENTOS SERIAL
