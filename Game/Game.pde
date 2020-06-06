Board board;
Room room;
Player player;
Camera camera;
Arrow arrow;

BoardFactory boardFactory;
ObstacleFactory obstacleFactory;

ArrayList<Obstacle> items;

int level = 0;

void setup() {
  size(1000, 700, P3D);
  items = new ArrayList<Obstacle>();
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
  room.setPlayer(player);
  room.display();
  // board.debug_show_elements_on_board();

  hint(DISABLE_DEPTH_TEST);
  arrow.display();
  showItemList();
  if (room.getItem() != null && room.getItem().getPickable()) {
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
  room = new Room(board);
  player = new Player();
  camera = new Camera(player);
  arrow = new Arrow(player);
}

void showItemList() {
  camera();
  for (int i = 0; i < items.size(); i++) {
    image(items.get(i).getIcon(), (1+i) * 100, height-100);
  }
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

    items.add(room.getItem());
    room.getItem().setPickable(false);
    board.free_element(room.itemP(), room.itemR());
  }
}
