class Thing {

  public PShape shape;
  public int p, r;

  public Thing() {
    shape = new PShape();
  }

  public Thing(PShape s, int p, int r) {
    this.shape = s;
    this.p = p;
    this.r = r;
  }
}
