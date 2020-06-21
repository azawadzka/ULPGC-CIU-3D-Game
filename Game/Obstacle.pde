class Obstacle {

  public PShape shape;
  public int size_p, size_r;
  private boolean pickable;  //With a boolean we identify which item is pickable or not

  private boolean unlockable;
  private String name;
  private String requirement;

  private PImage icon;

  public float offset_x, offset_y, offset_z;

  public Obstacle() {
    shape = new PShape();
  }


  public Obstacle(PShape s, boolean pick, PImage icon, boolean unlockable, String name, String requirement) {
    this.shape = s;
    this.pickable = pick;
    this.icon = icon;
    this.unlockable = unlockable;
    this.requirement = requirement;
    this.name=name;
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

  public void setPickable(boolean v) {
    this.pickable = v;
  }

  public boolean getPickable() {
    return this.pickable;
  }

  public PImage getIcon() {
    return icon;
  }


  public boolean isUnlockable() {
    return this.unlockable;
  }

  public void setUnlockable(boolean change) {
    unlockable = change;
  }

  public String getRequirement() {
    return requirement;
  }

  public String get_name() {
    return name;
  }
}
