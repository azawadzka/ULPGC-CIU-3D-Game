class FX {

  private float zoom;
  private PShader shader;

  public FX(PShader s) {
    this.shader = s;
  }

  public void start_game_over_shader() {
    zoom = 1.0;
    shader.set("u_face", float(width/2), float(height/2));
    shader.set("u_resolution", float(width), float(height));
  }

  public void apply_game_over_shader() {
    PImage c = get();
    filter(shader);
    shader.set("u_zoom", zoom);
    image(c, 0, 0);
    zoom *= 1.1;
  }

  public boolean has_gameover_finished() {
    if (zoom >= 500) return true;
    return false;
  }
}
