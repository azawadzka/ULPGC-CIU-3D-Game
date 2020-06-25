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

  int p, r; // board sizes
  float h = Room.ROOM_HEIGHT; // alias for readibility of vertex creation code where all parameters are single letters
  int parts_wall; 
  float h_part;


  public Room(Board board, Player player, Monster monster) {
    this.board = board;
    this.player = player;
    this.monster = monster;
    this.p = board.size_p;
    this.r = board.size_r;
    this.parts_wall = 3;
    this.h_part = h / this.parts_wall;

    normal_tex_floor = loadImage("resources/level" + level + "/floor.png");
    normal_tex_wall = loadImage("resources/level" + level + "/wall.png");
    normal_tex_ceiling = loadImage("resources/level" + level + "/ceil.png");
    debug_tex_floor = loadImage("resources/debug_floor.png");
    debug_tex_wall = loadImage("resources/debug_wall.png");
    debug_tex_ceiling = loadImage("resources/debug_ceil.png");

    this.set_textures(debug ? "DEBUG" : "NORMAL");
  }

  public void display() {
    game_layer.noStroke();
    emit_lights();
    display_floor();
    display_walls();
    display_ceiling();
    display_figures();
    if (monster != null) display_monster();
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
    for (int i = 0; i < p; i++) {
      for (int j = 0; j < r; j++) {
        game_layer.beginShape();
        game_layer.vertex(i * TILE, 0, j * TILE, 0, 0);
        game_layer.vertex(i * TILE, 0, (j+1) * TILE, 0, 1);
        game_layer.vertex((i+1) * TILE, 0, (j+1) * TILE, 1, 1);
        game_layer.vertex((i+1) * TILE, 0, j * TILE, 1, 0);
        game_layer.texture(tex_floor);
        game_layer.textureWrap(REPEAT);
        game_layer.endShape();
      }
    }
  }

  private void display_ceiling() {
    game_layer.beginShape();
    game_layer.vertex(0, h, 0, 0, 0);
    game_layer.vertex(0, h, r * TILE, 0, 1/p);
    game_layer.vertex(p * TILE, h, r * TILE, 1/p, 1/r);
    game_layer.vertex(p * TILE, h, 0, 1/p, 0);
    game_layer.texture(tex_ceiling);
    game_layer.textureWrap(REPEAT);
    game_layer.endShape();
  }

  private void display_walls() {
    for (int i = 0; i < p; i++) {
      for (int j = 0; j < r; j++) {
        for (int k = 0; k < parts_wall; k++) {
          game_layer.beginShape();
          game_layer.vertex(i * TILE, k * h_part, 0, 0, 0);
          game_layer.vertex(i * TILE, (k+1) * h_part, 0, 0, 1);
          game_layer.vertex((i+1) * TILE, (k+1) * h_part, 0, 1, 1);
          game_layer.vertex((i+1) * TILE, k * h_part, 0, 1, 0);
          game_layer.texture(tex_wall);
          game_layer.textureWrap(REPEAT);
          game_layer.endShape();    

          game_layer.beginShape();
          game_layer.vertex(p * TILE, k * h_part, j * TILE, 0, 0);
          game_layer.vertex(p * TILE, (k+1) * h_part, j * TILE, 0, 1);
          game_layer.vertex(p * TILE, (k+1) * h_part, (j+1) * TILE, 1, 1);
          game_layer.vertex(p * TILE, k * h_part, (j+1) * TILE, 1, 0);
          game_layer.texture(tex_wall);
          game_layer.textureWrap(REPEAT);
          game_layer.endShape();  

          game_layer.beginShape();
          game_layer.vertex((i+1) * TILE, k * h_part, r * TILE, 0, 0);
          game_layer.vertex((i+1) * TILE, (k+1) * h_part, r * TILE, 0, 1);
          game_layer.vertex(i * TILE, (k+1) * h_part, r * TILE, 1, 1);
          game_layer.vertex(i * TILE, k * h_part, r * TILE, 1, 0);
          game_layer.texture(tex_wall);
          game_layer.textureWrap(REPEAT);
          game_layer.endShape();

          game_layer.beginShape();
          game_layer.vertex(0, k * h_part, (j+1) * TILE, 0, 0);
          game_layer.vertex(0, (k+1) * h_part, (j+1) * TILE, 0, 1);
          game_layer.vertex(0, (k+1) * h_part, j * TILE, 1, 1);
          game_layer.vertex(0, k * h_part, j * TILE, 1, 0);
          game_layer.texture(tex_wall);
          game_layer.textureWrap(REPEAT);
          game_layer.endShape();
        }
      }
    }
  }

  private void display_monster() {
    game_layer.pushMatrix();
    game_layer.translate(monster.p * Room.TILE, 0, monster.r * Room.TILE); // I used (monster.x , 0, monster.z) before to have the movement animation but the monster was weirdly misplaced
    game_layer.translate(monster.offset_x, monster.offset_y, monster.offset_z);
    game_layer.shape(monster.model);
    game_layer.popMatrix();
  }

  private void emit_lights() {
    for (int i = 0; i < board.size_p; i++) {
      for (int j = 0; j < board.size_r; j++) {
        if (board.board[i][j] != null) {
          float px =  i * Room.TILE + board.board[i][j].offset_x;
          float py =  board.board[i][j].offset_y;
          float pz =  j * Room.TILE + board.board[i][j].offset_z;

          if (board.board[i][j].name == "torch") {
            game_layer.lightFalloff(0.15, 0.004, 0.00000001);
            game_layer.pointLight(255, 120, 0, px, py - 68, pz);
          } else if (board.board[i][j].name == "portal") {
            game_layer.lightFalloff(0.05, 0.001, 0.000001);
            game_layer.pointLight(50, 0, 100, px + 42, py - 75, pz);
          }
        }
      }
    }
    game_layer.lightFalloff(1.0, 0.0, 0.0);
  }

  private void display_figures() {
    for (int i = 0; i < board.size_p; i++) {
      for (int j = 0; j < board.size_r; j++) {
        if (board.board[i][j] != null) {
          game_layer.pushMatrix();
          game_layer.translate(i * Room.TILE, 0, j * Room.TILE);
          game_layer.translate(board.board[i][j].offset_x, board.board[i][j].offset_y, board.board[i][j].offset_z);
          game_layer.shape(board.board[i][j].shape);
          game_layer.popMatrix();
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
    fill(128);

    text("Press ", width/2-150, height/2+100);
    fill(255, 255, 0);
    if(control==0){
    text("B", width/2-150+textWidth("Press "), height/2+100);
    }else{
    text("F", width/2-150+textWidth("Press "), height/2+100);
    }
    
    fill(128);
    if(control==0){
        text(" to pick " + item.get_name(), width/2-150+textWidth("Press B"), height/2+100);
    }else{
        text(" to pick " + item.get_name(), width/2-150+textWidth("Press F"), height/2+100);
    }

    fill(255);
    hint(ENABLE_DEPTH_TEST);
  }

  private void showUnlockMessage() {
    hint(DISABLE_DEPTH_TEST);
    textSize(24);
    fill(128);

    if (player.owns_item_to_unlock(board.board[item_p][item_r].getRequirement())) {
      text("Press ", width/2-150, height/2+100);
      fill(255, 255, 0);
      text("B", width/2-150+textWidth("Press "), height/2+100);
      fill(128);
      text(" to unlock the path", width/2-150+textWidth("Press B"), height/2+100);
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
