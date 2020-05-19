class Room {
  
  public static final float TILE = 150;
  
  Board board;
  
  PShape floor;
  PImage tex_floor, tex_wall, tex_ceiling;
  
   
  float b; // board size
  float p; // floor texture proportion
  float h = -500; 
  
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
  }
  
  private void display_floor() {
    // PShape doesn't support texture wrap so manual vertex definition has been used
    beginShape();
    vertex(0,0,0,0,0);
    vertex(0,0,b,0,p);
    vertex(b,0,b,p,p);
    vertex(b,0,0,p,0);
    texture(tex_floor);
    textureWrap(REPEAT);
    endShape(); 
  }
  
  private void display_ceiling() {
    beginShape();
    vertex(0,h,0,0,0);
    vertex(0,h,b,0,p);
    vertex(b,h,b,p,p);
    vertex(b,h,0,p,0);
    texture(tex_ceiling);
    textureWrap(REPEAT);
    endShape(); 
  }
  
  private void display_walls() {
    beginShape();
    vertex(0,0,0,0,0);
    vertex(0,h,0,0,1);
    vertex(b,h,0,p,1);
    vertex(b,0,0,p,0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 
    
    beginShape();
    vertex(b,0,0,0,0);
    vertex(b,h,0,0,1);
    vertex(b,h,b,p,1);
    vertex(b,0,b,p,0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 
    
    beginShape();
    vertex(b,0,b,0,0);
    vertex(b,h,b,0,1);
    vertex(0,h,b,p,1);
    vertex(0,0,b,p,0);
    texture(tex_wall);
    textureWrap(REPEAT);
    endShape(); 
    
    beginShape();
    vertex(0,0,b,0,0);
    vertex(0,h,b,0,1);
    vertex(0,h,0,p,1);
    vertex(0,0,0,p,0);
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
          translate(board.board[i][j].offset_x, 0, board.board[i][j].offset_y);
          shape(board.board[i][j].shape);
          popMatrix();
        }
      }
    }
  }
  
  
}
