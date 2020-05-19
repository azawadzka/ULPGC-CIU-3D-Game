class Furniture {

  public PShape shape;
  public int p, r;
  public int size_p, size_r;
  
  public float offset_x, offset_y;

  public Furniture() {
    shape = new PShape();
  }

  public Furniture(PShape s, int p, int r) {
    this.shape = s;
    this.p = p;
    this.r = r;
  }
  
    public Furniture(PShape s, int p, int r, int s_p, int s_r) {
    this.shape = s;
    this.p = p;
    this.r = r;
    this.size_p = s_p;
    this.size_r = s_r;
  }
  
  public void set_offset(float offset_x, float offset_y){
    this.offset_x = offset_x;
    this.offset_y = offset_y;
  }
}
