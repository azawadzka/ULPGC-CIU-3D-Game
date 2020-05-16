//https://www.myminifactory.com/object/3d-print-venus-aphrodite-is-the-goddess-of-love-she-was-depicted-in-the-nude-or-in-various-stages-of-nudity-and-painted-the-figure-is-executed-in-the-hellenistic-style-and-famed-for-its-sensuous-appearance-it-supposedly-lost-its-arms-in-a-struggle-arising-b-25162
//https://opengameart.org/

public float ROTATION; // [-PI, PI]

Board board;
Room room;
Player player;
Camera camera;
Arrow arrow;

void setup() {
  size(1000,700, P3D);
  board = new Board();
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
  directionalLight(100, 100, 100, 0, 1, 0); // dim lights
  camera.cam();
  player.move();
  room.display();
  
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
