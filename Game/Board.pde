/*
Board

This class implements the placement of figures on a chessboard-like structure where an obstacle or the player can be placed
on spots and be recognised as a collisible object by other elements. It uses abstract coordinates on board P, R.

It does:
  - define board sizes size_p and size_r in constructor
  - have public methods put_on_board and remove_from_board (boolean to confirm if the action could be performed)
  - detect collisions
  - debug_show_elements_on_board
It doesn't:
  - draw anything or use any pixel values (except debug method debug_show_elements_on_board)
*/

class Board {

  int size_p, size_r;
  private Obstacle[][] board;
  
  int door_p, door_r;

  public Board(int size_p, int size_r, int door_p, int door_r) {
    this.size_p = size_p;
    this.size_r = size_r;
    this.door_p = door_p;
    this.door_r = door_r;

    board = new Obstacle[size_p][size_r];
  }

  public boolean is_free(int p, int r) {
    return check_if_free(p, r);
  }

  public boolean put_on_board(Obstacle element, int p, int r) {
    if (check_if_free(p, r)) {
      board[p][r] = element;
      return true;
    }
    print("Object could not be placed on board!");
    return false;
  }

  public boolean put_on_board(Obstacle element, int p, int r, int element_size_p, int element_size_r) {
    // check if all requested fields are free
    for (int i = p; i < p + element_size_p; i++) {
      for (int j = r; j < r + element_size_r; j++) {
        if (!check_if_free(i, j)) {
          print("Object could not be placed on board!");
          return false;
        }
      }
    }
    // put the obstacle
    Obstacle placeholder = new Obstacle();
    for (int i = p; i < p + element_size_p; i++) {
      for (int j = r; j < r + element_size_r; j++) {
        if (i == p && j == r) {
          board[i][j] = element;
        } else {
          board[i][j] = placeholder;
        }
      }
    }
    return true;
  }

  private boolean check_if_free(int p, int r) {
    if (p < 0 || p >= size_p) return false;
    if (r < 0 || r >= size_r) return false;
    if (board[p][r] != null) return false;
    return true;
  }
  
  public boolean remove_from_board(int p, int r) {
    if (board[p][r] == null) return false;
    board[p][r] = null;
    return true;
  }
  
  /*
  This method is for debugging. It paints in red the fields on board that have been 
  allocated with some PShapes using the public method put_on_board(). 
  You can use it so adjust positions of new objects that you are putting into the scene. 
  Use it in draw() function.
  */
  public void debug_show_elements_on_board() {
    PShape shape = createShape(BOX, Room.TILE);
    shape.setFill(color(255, 0, 0));
    shape.translate(0, Room.TILE*3/7, 0);
    for (int i = 0; i < size_p; i++) {
      for (int j = 0; j < size_r; j++) {
        if (board[i][j] != null) {
          game_layer.pushMatrix();
          game_layer.translate(i * Room.TILE + Room.TILE/2, 0, j * Room.TILE + Room.TILE/2);
          game_layer.shape(shape);
          game_layer.popMatrix();
        }
      }
    }
  }
}
