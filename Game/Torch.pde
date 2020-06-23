class Torch {
  
  Player player;
  int length, h = -80;
  int concentration = 50;
  
  public Torch(Player player) {
    this.player = player;
  }
  
  public void light() {
    float lookY = map(mouseY, 0, height, -300, 00);
    
    float x = player.x;
    float y = lookY;
    float z = player.z;
    
    float direction_x;
    float direction_z;
    
    if (mouseX < width/2) {
      direction_x = map(mouseX, 0, width/2, -1, 1);
    } else {
      direction_x = map(mouseX, width/2, width, 1, -1);
    }
    
    if (mouseX < width/4) {
      direction_z = map(mouseX, 0, width/4, 0, -1);
    } else if (mouseX < width*3/4) {
      direction_z = map(mouseX, width/4, width*3/4, -1, 1);
    } else {
      direction_z = map(mouseX, width*3/4, width, 1, 0);
    }
    
    game_layer.spotLight(255, 255, 200, x, y, z, direction_x, 0, direction_z, PI/12, concentration);
  }
  
}
