class Player {

  public static final int MOVE_TIME = 30;

  Board board;

  //-----------------------------------------------------PLEASE MOVE IT TO ANOTHER CLASS-------------------------------
  Inventory inventory;
  //-------------------------------------------------------------------------------------------------------------------

  private float x, z;
  int p, r; //coordinates on the board
  int timer = 0;
  int move_p = 0, move_r = 0;

  public Player(Inventory i, Board board) {
    this.inventory = i;
    this.board = board;
    this.x = Room.TILE/2;
    this.z = Room.TILE/2;
    this.p=0; 
    this.r=0;
  }

  //-----------------------------------------------------PLEASE MOVE IT TO ANOTHER CLASS-------------------------------
  private boolean owns_item_to_unlock(String neededItemName) {
    if (inventory.getItemByName(neededItemName) != null) {
      return true;
    }
    return false;
  }
  //-------------------------------------------------------------------------------------------------------------------

  public boolean request_move() {
    if (!ready_to_move()) return false;
    int[] val = getWalkingDirection();
    if (allowed_move(val[0], val[1])) {
      p += val[0];
      r += val[1];
      move_p = val[0];
      move_r = val[1];
      timer = MOVE_TIME;
      return true;
    }
    return false;
  }

  private boolean allowed_move(int mp, int mr) {
    return board.is_free(p + mp, r + mr);
  }

  private boolean ready_to_move() {
    return timer == 0;
  }

  public boolean is_moving() {
    return timer != 0;
  }

  private void move() {
    if (timer != 0) {
      x += move_p * Room.TILE/MOVE_TIME;
      z += move_r * Room.TILE/MOVE_TIME;
      timer--;
    }
  }

  public int getP() {
    return p;
  }

  public int getR() {
    return r;
  }
}
