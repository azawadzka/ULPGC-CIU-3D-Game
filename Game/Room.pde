class Room {

  public static final float TILE = 150;
  public static final float ROOM_HEIGHT = -500;

  Board board;

  Player player;  //Get player position

  Obstacle item;  //Get the current interactable item
  int item_p; //current interactable item position i
  int item_r; //current interactable item position j

PImage tex_floor, tex_wall, tex_ceiling, normal_tex_floor, normal_tex_wall, normal_tex_ceiling, debug_tex_floor, debug_tex_wall, debug_tex_ceiling;


  float b; // board size
  float p; // floor texture proportion
  float h = Room.ROOM_HEIGHT; // alias for readibility of vertex creation code where all parameters are single letters

  boolean pickable;


  public Room(Board board, Player player) {
    this.board = board;
    this.player = player;
    this.b = board.size * TILE;
    this.p = board.size;

    normal_tex_floor = loadImage("resources/floor.png");
    normal_tex_wall = loadImage("resources/wall.png");
    normal_tex_ceiling = loadImage("resources/ceil.png");
    debug_tex_floor = loadImage("resources/debug_floor.png");
    debug_tex_wall = loadImage("resources/debug_wall.png");
    debug_tex_ceiling = loadImage("resources/debug_ceil.png");

    this.set_textures(debug ? "DEBUG" : "NORMAL");
  }

  public void display() {
    display_floor();
    display_walls();
    display_ceiling();
    display_figures();
    display_and_update_current_item();
    check_ending_level();
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


  private void display_and_update_current_item() {
    for (int i = 0; i < board.size; i++) {
      for (int j = 0; j < board.size; j++) {
        if (board.board[i][j] != null) {
          if (board.board[i][j].isUnlockable() && isOnRangeUnlock(i, j)) {
            update_item_info(i, j);
            showUnlockMessage();
            return;
          } else if (board.board[i][j].pickable && isOnRange(i, j)) {
            update_item_info(i, j);
            showText();
            return;
          }
        }
      }
    }
    item = null;
  }


  private boolean player_can_unlock() {

    if (item == null) return false;
    else if (item.getRequirement() == null) return false;

    for (int i = 0; i < board.size; i++) {
      for (int j = 0; j < board.size; j++) {
        if (board.board[i][j] != null) {
          if (isOnRangeUnlock(i, j)) {
            if (board.board[i][j].isUnlockable()) {
              return player.owns_item_to_unlock(board.board[item_p][item_r].getRequirement());
            }
          }
        }
      }
    }

    return false;
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


  private boolean isOnRangeUnlock(int i, int j) {
    //Hacer las condiciones de control de outOfBounds
    if (player.getP() == i && player.getR() == j-1) return true;
    if (player.getP() == i-1 && player.getR() == j) return true;
    if (player.getP() == i+1 && player.getR() == j) return true;
    if (player.getP() == i && player.getR() == j+1) return true;
    return false;
  }

  private void showText() {
    hint(DISABLE_DEPTH_TEST);

    textSize(24);
    camera();
    fill(128);

    text("Press ", width/2-150, height/2+100);
    fill(255, 255, 0);
    text("F", width/2-150+textWidth("Press "), height/2+100);
    fill(128);
    text(" to pay respects", width/2-150+textWidth("Press F"), height/2+100);
    fill(255);
    hint(ENABLE_DEPTH_TEST);
  }

  private void showUnlockMessage() {

    hint(DISABLE_DEPTH_TEST);

    textSize(24);
    camera();
    fill(128);

    if (player.owns_item_to_unlock(board.board[item_p][item_r].getRequirement())) {
      text("Pulsa ", width/2-150, height/2+100);
      fill(255, 255, 0);
      text("B", width/2-150+textWidth("Pulsa "), height/2+100);
      fill(128);
      text(" para romper la pared", width/2-150+textWidth("Pulsa B"), height/2+100);
      fill(255);
    } else {
      text("Necesitas el objeto ", width/2-150, height/2+100);
      fill(0, 0, 255);
      text( board.board[item_p][item_r].getRequirement(), width/2-150+textWidth("Necesitas el objeto "), height/2+100);
      fill(255);
    }
    hint(ENABLE_DEPTH_TEST);
  }

  private void update_item_info(int i, int j) {
    item_p = i;
    item_r = j;
    this.item = board.board[item_p][item_r];
  }


  private boolean check_ending_level() {
    if (board.ending_p == player.getP() && board.ending_r == player.getR()) {
      return true;
    }
    return false;
  }


  public Obstacle getItem() {
    return item;
  }
  
  
  public void set_textures(String mode) {
    // modes: NORMAL, DEBUG
    if (mode == "NORMAL") {
      tex_floor = normal_tex_floor;
      tex_wall = normal_tex_wall;
      tex_ceiling = normal_tex_ceiling;
    } else if (mode == "DEBUG") {
      tex_floor = debug_tex_floor;
      tex_wall = debug_tex_wall;
      tex_ceiling = debug_tex_ceiling;
    }
  }
}
