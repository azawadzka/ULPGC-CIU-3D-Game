class Inventory {

  ArrayList<Obstacle> items;

  public Inventory() {
    items = new ArrayList<Obstacle>();
  }

  public void display() {
    camera();
    for (int i = 0; i < items.size(); i++) {
      image(items.get(i).getIcon(), (1+i) * 100, height-100);
    }
  }

  public Obstacle getItemByName(String itemName) {
    for (int i = 0; i < items.size(); i++) {
      if (items.get(i).get_name() == itemName) {
        return items.get(i);
      }
    }
    return null;
  }

  public void addItem(Obstacle item) {
    items.add(item);
  }

  public void removeItem(Obstacle item) {
    for (int i = 0; i < items.size(); i++) {
      if (items.get(i).get_name() == item.getRequirement()) {
        items.remove(i);
        break;
      }
    }
  }
  
  //public ArrayList<Obstacle> get_list(){ return items;}
  
}
