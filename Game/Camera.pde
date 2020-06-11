class Camera {

  public static final int CAMERA_HEIGHT = -100;

  Player player;
  float view_length = 10000;

  public Camera(Player player) {
    this.player = player;
  }

  public void cam() {  
    float x = view_length * sin(PI/2) * cos(ROTATION);
    float z = view_length * sin(PI/2) * sin(ROTATION);

    camera(player.x, CAMERA_HEIGHT, player.z, x, CAMERA_HEIGHT, z, 0, 1, 0);
  }
}
