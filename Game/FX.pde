class FX {

  private float zoom;
  private PShader shader;
  private int tint;

  private PFont font_game_over;

  public FX(PShader s) {
    this.shader = s;
  }

  public void start_game_over_shader() {
    zoom = 1.0;
    shader.set("u_face", float(width/2), float(height/2));
    shader.set("u_resolution", float(width), float(height));
    tint = 0;
    font_game_over = createFont("resources/fonts/youmurdererbb_reg.ttf", 156);
  }

  public void apply_game_over_shader() {
    PImage c = get();
    filter(shader);
    shader.set("u_zoom", zoom);
    image(c, 0, 0);
    zoom *= 1.14;
  }

  public boolean has_gameover_finished() {
    if (zoom >= 500) return true;
    return false;
  }


  public void gameover_screen() {
    top_layer.background(0);
    top_layer.fill(255, 0, 0, tint);
    top_layer.tint(tint);
    top_layer.textAlign(CENTER);
    top_layer.textFont(font_game_over);
    top_layer.text("GAME OVER", width/2, height/2);
    tint++;
    if (tint >= 255)tint = 255;
  }
}
