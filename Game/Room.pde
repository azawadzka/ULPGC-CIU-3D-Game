class Room {

  public static final float TILE = 150;
  public static final float ROOM_HEIGHT = -500;

  Board board;

  Player player;  //Get player position

  Obstacle item;  //Get the item to pick

  PShape floor;
  PImage tex_floor, tex_wall, tex_ceiling;

  int item_p; //pickable item position i
  int item_r; //pickable item position j

  float b; // board size
  float p; // floor texture proportion
  float h = Room.ROOM_HEIGHT; // alias for readibility of vertex creation code where all parameters are single letters

  boolean pickable;

  public Room(Board board) {
    this.board = board;
    this.b = board.size * TILE;
    this.p = board.size;

    tex_floor = loadImage("resources/floor.png");
    tex_wall = loadImage("resources/wall.png");
    tex_ceiling = loadImage("resources/ceil.png");
  }

  public void display() {
    display_floor();
    display_walls();
    display_ceiling();
    display_figures();
    pickableObject();
  }

  private void display_floor() {
    // PShape doesn't support texture wrap so manual vertex definition has been used
    beginShape();
    vertex(0, 0, 0, 0, 0);
    vertex(0, 0, b, 0, p);
    vertex(b, 0, b, p, p);
    vertex(b, 0, 0, p, 0);
    texture(tex_floor);
    textureWrap(REPEAT);
    endShape();
  }

  private void display_ceiling() {
    beginShape();
    vertex(0, h, 0, 0, 0);
    vertex(0, h, b, 0, p);
    vertex(b, h, b, p, p);
    vertex(b, h, 0, p, 0);
    texture(tex_ceiling);
    textureWrap(REPEAT);
    endShape();
  }

  private void display_walls() {
    beginShape();
    vertex(0, 0, 0, 0, 0);
    vertex(0, h, 0, 0, 1);
    vertex(b, h, 0, p, 1);
    vertex(b, 0, 0, p, 0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 

    beginShape();
    vertex(b, 0, 0, 0, 0);
    vertex(b, h, 0, 0, 1);
    vertex(b, h, b, p, 1);
    vertex(b, 0, b, p, 0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 

    beginShape();
    vertex(b, 0, b, 0, 0);
    vertex(b, h, b, 0, 1);
    vertex(0, h, b, p, 1);
    vertex(0, 0, b, p, 0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 

    beginShape();
    vertex(0, 0, b, 0, 0);
    vertex(0, h, b, 0, 1);
    vertex(0, h, 0, p, 1);
    vertex(0, 0, 0, p, 0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape();
  }

  private void display_figures() {
    for (int i = 0; i < board.size; i++) {
      for (int j = 0; j < board.size; j++) {
        if (board.board[i][j] != null) {
          pushMatrix();
          translate(i * Room.TILE, 0, j * Room.TILE);
          translate(board.board[i][j].offset_x, board.board[i][j].offset_y, board.board[i][j].offset_z);
          shape(board.board[i][j].shape);
          popMatrix();
        }
      }
    }
  }



  private void pickableObject() {
    for (int i = 0; i < board.size; i++) {
      for (int j = 0; j < board.size; j++) {
        if (board.board[i][j] != null) {
          if (i-1 >=0  && j-1 >= 0) {  //Quitar esta condicion para hacerlo en isOnRange
            if (board.board[i][j].pickable && isOnRange(i, j)) {
              camera();
              item_p = i;
              item_r = j;
              showText();
              item = board.board[i][j];
              return;
            }
          }
        }
      }
    }
    item = null;
  }

  private boolean isOnRange(int i, int j) {
    //Hacer las condiciones de control de outOfBounds
    if (player.getP() == i-1 && player.getR() == j-1) return true;
    if (player.getP() == i && player.getR() == j-1) return true;
    if (player.getP() == i+1 && player.getR() == j-1) return true;
    if (player.getP() == i-1 && player.getR() == j) return true;
    if (player.getP() == i+1 && player.getR() == j) return true;
    if (player.getP() == i-1 && player.getR() == j+1) return true;
    if (player.getP() == i && player.getR() == j+1) return true;
    if (player.getP() == i+1 && player.getR() == j+1) return true;
    return false;
  }

  private void showText() {
    hint(DISABLE_DEPTH_TEST);
    textSize(24);
    fill(128);
    text("Press ", width/2-150, height/2+100);
    fill(255, 255, 0);
    text("F", width/2-150+textWidth("Press "), height/2+100);
    fill(128);
    text(" to pay respects", width/2-150+textWidth("Press F"), height/2+100);
    fill(255);
    hint(ENABLE_DEPTH_TEST);
  }

  public void setPlayer(Player pl) {
    this.player = pl;
  }

  public Obstacle getItem() {
    return item;
  }

  public int itemP() {
    return item_p;
  }
  public int itemR() {
    return item_r;
  }
}
