
import processing.video.*;
import processing.serial.*;
Capture cam;

Board board;
Room room;
Player player;
Camera camera;
Arrow arrow;
Menu menu;
int tint;

int status;  //which part is the player

//COSAS PARA LECTOR SERIAL
int [] buffer= new int[3] ;
public int control=0;  //Para cambiar el control remoto.
public Serial arduinoSerial; //Conexion al Serial


int joystickX=500; //rotación de la camara

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
  tint=0;
  //noCursor();

  try {
    arduinoSerial= new Serial(this, Serial.list()[0], 9600 );
  }
  catch(Exception e) {
    control=1;
  }

  //cam para demostracion
  //cam = new Capture(this, 640, 480);
  //cam.start();
}

void draw() {  
  switch(status) {
  case 0:
    menu.display();
    break;
  case 1:
    menu.controllers();
    break;
  case 2:
    menu.credits();
    break;
  case 3:
    updateRotation();

    hint(ENABLE_DEPTH_TEST); 
    //directionalLight(100, 100, 100, 0, 1, 0); // dim lights
    lights();
    camera.cam();
    player.move();
    room.display();
    if (room.check_ending_level()) {
      transicion();
    } else {
      fill(255, 255, 255, 255);
      tint=0;
    }
    // board.debug_show_elements_on_board();

    hint(DISABLE_DEPTH_TEST);
    arrow.display();
    player.inventory.display();

    /*if (cam.available()) {
     cam.read();
     image(cam, 0, 0, 320, 240);
     }*/
    break;
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
  switch(status) {
  case 0:
    if (keyCode==UP) {
      menu.options--;
      if (menu.options<0)menu.options=2;
    } else if (keyCode==DOWN) {
      menu.options++;
      if (menu.options>2)menu.options=0;
    }

    if (keyCode==ENTER) {

      switch(menu.options) {
      case 0:
        status=3;
        menu.intro.stop();
        textFont(createFont("SansSerif", 16));
        break;
      case 1:
        status=1;
        break;
      case 2:
        status=2;
        break;
      }
    }

    break;
  case 1:
    if (keyCode == ENTER) {
      status=0;
    }
    break;

  case 2:
    if (keyCode == ENTER) {
      status=0;
    }  
    break;

  case 3:
    if (key == 'l') next_level();

    if (room.getItem() != null && (key == 'F' || key == 'f') && room.getItem().getPickable()) {
      Obstacle item = room.getItem();
      item.setPickable(false);
      player.inventory.addItem(item);
      board.free_element(room.item_p, room.item_r);
    }

    if ((key == 'B' || key == 'b') && room.player_can_unlock()) { //room.getLockedObject() != null &&  && room.getLockedObject().isUnlockable()
      board.free_element(room.item_p, room.item_r);    
      player.inventory.removeItem(room.getItem());
      player.inventory.display();
    }
    break;
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
