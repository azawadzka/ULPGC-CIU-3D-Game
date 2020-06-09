class Board {
  
  int size;
  private Obstacle[][] board;
  
  int ending_p;
  int ending_r;
  
  public Board(int size) {
    this.size = size;
    board = new Obstacle[size][size];
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
  
  public boolean put_on_board(Obstacle element, int p, int r, int size_p, int size_r) {
    for (int i = p; i < p + size_p; i++) {
      for (int j = r; j < r + size_r; j++) {
        if (!check_if_free(i, j)) {
          print("Object could not be placed on board!");
          return false;
        }
      }
    }
    
    Obstacle placeholder = new Obstacle();
    for (int i = p; i < p + size_p; i++) {
      for (int j = r; j < r + size_r; j++) {
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
    if (p < 0 || p >= size) return false;
    if (r < 0 || r >= size) return false;
    if (board[p][r] != null) return false;
    return true;
  }
  
  public void free_element(int p, int r){
    board[p][r] = null;
  }
  
  public void ending_level(int p, int r){
    ending_p = p;
    ending_r = r;
  }
  
  /*
  This method is for debugging. It paints in red the fields on board that have been 
  allocated with some PShapes using the public method put_on_board(). 
  You can use it so adjust positions of new objects that you are putting into the scene. 
  Use it in draw() function.
  */
  public void debug_show_elements_on_board() {
    PShape shape = createShape(BOX, Room.TILE);
    shape.setFill(color(255,0,0));
    shape.translate(0, Room.TILE*3/7, 0);
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] != null) {
          pushMatrix();
          translate(i * Room.TILE + Room.TILE/2, 0, j * Room.TILE + Room.TILE/2);
          shape(shape);
          popMatrix();
        }
      }
    }
  }
}
