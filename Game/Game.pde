Board board;
Room room;
Player player;
Camera camera;
Arrow arrow;

BoardFactory boardFactory;
ObstacleFactory obstacleFactory;

int level = 0;

void setup() {
  size(1000, 700, P3D);
  obstacleFactory = new ObstacleFactory();
  boardFactory = new BoardFactory();
  next_level();
  smooth(8);
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
  if(room.check_ending_level()){
    next_level();
  }
  // board.debug_show_elements_on_board();

  hint(DISABLE_DEPTH_TEST);
  arrow.display();
  player.inventory.display();
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
    board.free_element(room.item_p, room.item_r);
  }

  if ((key == 'B' || key == 'b') && room.player_can_unlock()) { //room.getLockedObject() != null &&  && room.getLockedObject().isUnlockable()
    board.free_element(room.item_p, room.item_r);    
    player.inventory.removeItem(room.getItem());
    player.inventory.display();
  }
}
