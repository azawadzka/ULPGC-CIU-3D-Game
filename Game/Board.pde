class Board {
  
  int size;
  PShape[][] board;
  
  public Board() {
    this.size = 8;
    board = new PShape[size][size];
  }
  
  public boolean is_free(int p, int r) {
    if (p < 0 || p >= size) return false;
    if (r < 0 || r >= size) return false;
    if (board[p][r] != null) return false;
    return true;
  }
}
