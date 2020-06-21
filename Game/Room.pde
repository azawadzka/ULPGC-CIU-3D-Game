/*
Room
 
 This class draws the Board that has been passed as an argument of its constructor. It stores all data that is 
 characteristic to the instance of chamber. 
 
 It does: 
 - store all information that is necessery to draw a chamber, that is: the board (sizes, objects, etc.) and all 
 visual data (pixel sizes, brushes and textures)
 - perform the drawing
 It doesn't:
 - do any logical operations like putting on board, detecting collisions, interact with objects
 - draw the user interface
 */

class Room {

  public static final float TILE = 150;
  public static final float ROOM_HEIGHT = -500;

  Board board;

  Player player;  //Get player position
  Monster monster;  //Get player position

  Obstacle item;  //Get the current interactable item
  int item_p; //current interactable item position i
  int item_r; //current interactable item position j

  PImage tex_floor, tex_wall, tex_ceiling, normal_tex_floor, normal_tex_wall, normal_tex_ceiling, debug_tex_floor, debug_tex_wall, debug_tex_ceiling;

  float bp, br; // board sizes
  float tp, tr; // floor texture proportion
  float h = Room.ROOM_HEIGHT; // alias for readibility of vertex creation code where all parameters are single letters


  public Room(Board board, Player player, Monster monster) {
    this.board = board;
    this.player = player;
    this.monster = monster;
    this.bp = board.size_p * TILE;
    this.br = board.size_r * TILE;
    this.tp = board.size_p;
    this.tr = board.size_r;

    normal_tex_floor = loadImage("resources/level" + level + "/floor.png");
    normal_tex_wall = loadImage("resources/level" + level + "/wall.png");
    normal_tex_ceiling = loadImage("resources/level" + level + "/ceil.png");
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
    if(monster != null) display_monster();
    display_and_update_current_item();
    check_ending_level();
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

  private void display_floor() {
    // PShape doesn't support texture wrap so manual vertex definition has been used
    beginShape();
    vertex(0, 0, 0, 0, 0);
    vertex(0, 0, br, 0, tr);
    vertex(bp, 0, br, tp, tr);
    vertex(bp, 0, 0, tp, 0);
    texture(tex_floor);
    textureWrap(REPEAT);
    endShape();
  }

  private void display_ceiling() {
    beginShape();
    vertex(0, h, 0, 0, 0);
    vertex(0, h, br, 0, tr);
    vertex(bp, h, br, tp, tr);
    vertex(bp, h, 0, tp, 0);
    texture(tex_ceiling);
    textureWrap(REPEAT);
    endShape();
  }

  private void display_walls() {
    beginShape();
    vertex(0, 0, 0, 0, 0);
    vertex(0, h, 0, 0, 1);
    vertex(bp, h, 0, tp, 1);
    vertex(bp, 0, 0, tp, 0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 

    beginShape();
    vertex(bp, 0, 0, 0, 0);
    vertex(bp, h, 0, 0, 1);
    vertex(bp, h, br, tr, 1);
    vertex(bp, 0, br, tr, 0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 

    beginShape();
    vertex(bp, 0, br, 0, 0);
    vertex(bp, h, br, 0, 1);
    vertex(0, h, br, tp, 1);
    vertex(0, 0, br, tp, 0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 

    beginShape();
    vertex(0, 0, br, 0, 0);
    vertex(0, h, br, 0, 1);
    vertex(0, h, 0, tr, 1);
    vertex(0, 0, 0, tr, 0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape();
  }

  private void display_monster() {
    pushMatrix();
    translate(monster.p * Room.TILE, 0, monster.r * Room.TILE); // I used (monster.x , 0, monster.z) before to have the movement animation but the monster was weirdly misplaced
    translate(monster.offset_x, monster.offset_y, monster.offset_z);
    shape(monster.model);
    popMatrix();
  }

  private void display_figures() {
    for (int i = 0; i < board.size_p; i++) {
      for (int j = 0; j < board.size_r; j++) {
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

  //-----------------------------------------------------PLEASE MOVE IT TO ANOTHER CLASS-------------------------------
  private void display_and_update_current_item() {
    for (int i = 0; i < board.size_p; i++) {
      for (int j = 0; j < board.size_p; j++) {
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

    for (int i = 0; i < board.size_p; i++) {
      for (int j = 0; j < board.size_r; j++) {
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
    text(" to pick " + item.get_name(), width/2-150+textWidth("Press F"), height/2+100);
    fill(255);
    hint(ENABLE_DEPTH_TEST);
  }

  private void showUnlockMessage() {

    hint(DISABLE_DEPTH_TEST);

    textSize(24);
    camera();
    fill(128);

    if (player.owns_item_to_unlock(board.board[item_p][item_r].getRequirement())) {
      text("Press ", width/2-150, height/2+100);
      fill(255, 255, 0);
      text("B", width/2-150+textWidth("Pulsa "), height/2+100);
      fill(128);
      text(" to unlock the path", width/2-150+textWidth("Pulsa B"), height/2+100);
      fill(255);
    } else {
      text("You need ", width/2-150, height/2+100);
      fill(0, 0, 255);
      text( board.board[item_p][item_r].getRequirement(), width/2-150+textWidth("You need "), height/2+100);
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
    if (board.door_p == player.getP() && board.door_r == player.getR()) {
      return true;
    }
    return false;
  }


  public Obstacle getItem() {
    return item;
  }

  
}
//------------------------------------------------------------------------------------------------------------------------------
