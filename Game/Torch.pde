class Torch {
  
  Player player;
  int length, h = -80;
  int concentration = 50;
  
  public Torch(Player player) {
    this.player = player;
  }
  
  public void light() {
    float lookY = map(mouseY, 0, height, -300, 00);
    
    float x = player.get_x();
    float y = lookY;
    float z = player.get_z();
    
    float direction_x;
    float direction_z;
    
    if (ROTATION < 0) {
      direction_x = map(ROTATION, -PI, 0, -1, 1);
    } else {
      direction_x = map(ROTATION, 0, PI, 1, -1);
    }
    
    if (ROTATION < -PI/2) {
      direction_z = map(ROTATION, -PI, -PI/2, 0, -1);
    } else if (ROTATION < PI/2) {
      direction_z = map(ROTATION, -PI/2, PI/2, -1, 1);
    } else {
      direction_z = map(ROTATION, PI/2, PI, 1, 0);
    }
    
    // 2 lights give better effect, whoever can do this better, go ahead
    game_layer.spotLight(255, 255, 200, x, y, z, direction_x, 0, direction_z, PI/12, concentration);
    game_layer.spotLight(255, 255, 200, x, y, z, direction_x, 0, direction_z, PI/12, concentration);
    
  }
  
}
