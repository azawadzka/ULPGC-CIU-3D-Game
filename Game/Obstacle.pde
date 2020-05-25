class Obstacle {

  public PShape shape;
  public int size_p, size_r;
  public boolean pickable;  //With a boolean we identify which item is pickable or not
  
  PImage image;
  

  public float offset_x, offset_y, offset_z;

  public Obstacle() {
    shape = new PShape();
  }

  public Obstacle(PShape s, boolean pick, PImage image) {
    this.shape = s;
    this.pickable = pick;
    this.image = image;
  }

  public Obstacle(PShape s, int s_p, int s_r) {
    this.shape = s;
    this.size_p = s_p;
    this.size_r = s_r;
  }

  public void set_offset(float offset_x, float offset_y, float offset_z) {
    this.offset_x = offset_x;
    this.offset_y = offset_y;
    this.offset_z = offset_z;
  }
  
  public void setPickable(boolean v){
    this.pickable = v;
  }
  
  public boolean getPickable(){
    return this.pickable;
  }
  
  public PImage getImage(){
    return image;
  }
  
  
  
  
  
}
