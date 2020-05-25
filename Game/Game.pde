Board board;
Room room;
Player player;
Camera camera;
Arrow arrow;

ObstacleFactory obstacleFactory;

ArrayList<Obstacle> items;


void setup() {
  size(1000, 700, P3D);
  items = new ArrayList<Obstacle>();
  board = new Board();
  obstacleFactory = new ObstacleFactory();
  createGameObjects();
  room = new Room(board);
  player = new Player();
  camera = new Camera(player);
  arrow = new Arrow(player);
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

void showItemList() {
  camera();
  for (int i = 0; i< items.size(); i++) {
    image(items.get(i).getImage(), 20, height-100);
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
  if (room.getItem() != null && (key == 'F' || key == 'f') && room.getItem().getPickable()) {
    
    items.add(room.getItem());
    room.getItem().setPickable(false);
    board.free_element(room.itemP(), room.itemR());
  }
}
