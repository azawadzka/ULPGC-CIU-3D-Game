class Monster {

  public static final int MOVE_TIME = 30;

  Board board;

  public PShape model;

  private float x, z;
  int p, r; //coordinates on the board
  int timer = 0;
  int move_p = 0, move_r = 0;

  public float offset_x, offset_y, offset_z;

  private AI_Type ai_type;

  public Monster(AI_Type ai_type, Board board, int init_p, int init_r, PShape model) {
    this.ai_type = ai_type;
    this.board = board;
    this.p = init_p; 
    this.r = init_r;
    this.x = Room.TILE/2 * (p + 1);
    this.z = Room.TILE/2 * (r + 1);
    this.model = model;
  }

  public void set_offset(float offset_x, float offset_y, float offset_z) {
    this.offset_x = offset_x;
    this.offset_y = offset_y;
    this.offset_z = offset_z;
  }

  private int[] do_RANDOM_walk() {
    int[] displacement = {0, 0};

    switch(round(random(0, 3))) {

    case 0: 
      displacement[0] = 1;
      break;
    case 1: 
      displacement[0] = -1;
      break;
    case 2: 
      displacement[1] = 1;
      break;
    case 3: 
      displacement[1] = -1;
      break;
    }

    return displacement;
  }

  public boolean request_move() {
    if (!ready_to_move()) return false;

    int[] displacement = {0, 0};

    int max_attempts = 4; // try at most 4 times to move. Could be that monster is cornered in. Avoids an infinite loop of tries.

    for (int i = 0; i < max_attempts; i++) {
      switch(ai_type) {

      case RANDOM: 
        displacement = do_RANDOM_walk();
        break;

      default:
        println("No ai_type for monster. Monster will not move");
        break;
      }

      if (allowed_move(displacement[0], displacement[1])) {
        p += displacement[0];
        r += displacement[1];
        move_p = displacement[0];
        move_r = displacement[1];
        timer = MOVE_TIME;
        return true;
      }
    }
    return false;
  }

  private boolean allowed_move(int mp, int mr) {
    return board.is_free(p + mp, r + mr);
  }

  private boolean ready_to_move() {
    return timer == 0;
  }

  private void move() {
    if (timer != 0) {
      x += move_p * Room.TILE/MOVE_TIME;
      z += move_r * Room.TILE/MOVE_TIME;
      timer--;
    }
  }

  public boolean is_moving() {
    return timer != 0;
  }

  public int getP() {
    return p;
  }

  public int getR() {
    return r;
  }
}

public enum AI_Type {
  RANDOM
}
