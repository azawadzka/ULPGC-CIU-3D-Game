Board board;
Room room;
Player player;
Camera camera;
Arrow arrow;

ThingFactory thingFactory;

void setup() {
  size(1000, 700, P3D);
  board = new Board();
  thingFactory = new ThingFactory();
  createGameObjects();
  room = new Room(board);
  player = new Player();
  camera = new Camera(player);
  arrow = new Arrow(player);
  smooth(8);
  //noCursor();
}

void createGameObjects() {

  Thing a = thingFactory.createWall(4, 3);
  board.put_on_board(a, a.p, a.r, 2, 3);
}

void draw() {  
  updateRotation();

  hint(ENABLE_DEPTH_TEST); 
  //directionalLight(100, 100, 100, 0, 1, 0); // dim lights
  lights();
  camera.cam();
  player.move();
  room.display();
  board.debug_show_elements_on_board();

  hint(DISABLE_DEPTH_TEST);
  arrow.display();
}

void mouseClicked() {
  if (player.request_move()) {
    arrow.cancel_false_click();
  } else {
    arrow.set_false_click();
  }
}
