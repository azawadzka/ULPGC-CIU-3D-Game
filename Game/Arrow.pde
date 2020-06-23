public final int ARROW_HEIGHT = -30;
public final int ARROW_DISTANCE_FROM_PLAYER = 150;

class Arrow {

  float a=8, b=20, c=30, d=50; // arrow proportions
  PShape arrow;
  Player player;
  color white = color(255, 255, 255, 255);
  int false_click_timer = 0, false_click = 30; // timer after unallowed direction clicked 

  public Arrow(Player player) {
    this.player = player;
    arrow = createShape();
    arrow.scale(0.4);
    arrow.rotateY(-PI/2);
    arrow.setStroke(false);
    arrow.setFill(white);
    arrow.beginShape();
    arrow.vertex(a, 0, 0);
    arrow.vertex(a, 0, c);
    arrow.vertex(b, 0, c);
    arrow.vertex(0, 0, d);
    arrow.vertex(-b, 0, c);
    arrow.vertex(-a, 0, c);
    arrow.vertex(-a, 0, 0);
    arrow.endShape();
  }

  public void display() {
    drawArrow();
  }

  private void drawArrow() {
    float x = ARROW_DISTANCE_FROM_PLAYER * sin(PI/2) * cos(ROTATION);
    float z = ARROW_DISTANCE_FROM_PLAYER * sin(PI/2) * sin(ROTATION);

    game_layer.pushMatrix();
    game_layer.translate(player.x + x, ARROW_HEIGHT, player.z + z);

    float div = floor(ROTATION / (PI/2) + 0.5);
    game_layer.rotateY(-div * PI/2 + PI);
    game_layer.shape(arrow);
    game_layer.popMatrix();
  }

  public void set_false_click() {
    false_click_timer = false_click;
  }

  public void cancel_false_click() {
    false_click_timer = 0;
  }
}
