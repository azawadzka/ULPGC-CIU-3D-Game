class ObstacleFactory {

  Obstacle createWall() {

    //Parameters: PShape s, boolean pick, PImage icon,boolean unlockable,String name,String requirement
    Obstacle wall = new Obstacle(createShape(BOX, Room.TILE, Room.ROOM_HEIGHT, Room.TILE), false, null, false, "0", "0");
    wall.set_offset(Room.TILE/2, Room.ROOM_HEIGHT/2, Room.TILE/2); // to center wall on tile
    return wall;
  }

  Obstacle bomb() {
    PShape bombModel = loadShape("resources/bomb/model.obj");
    bombModel.scale(25, -25, 25);
    Obstacle bombObstacle = new Obstacle(bombModel, true, loadImage("resources/bomb/bomb.png"), false, "Bomba", "");
    bombObstacle.set_offset(Room.TILE/2, 0, Room.TILE/2); // to center object on tile
    return bombObstacle;
  }

  Obstacle destructiveWall() {    
    fill(255, 0, 0);
    Obstacle wall = new Obstacle(createShape(BOX, Room.TILE, Room.ROOM_HEIGHT, Room.TILE), false, null, true, "", "Bomba");
    fill(255);
    wall.set_offset(Room.TILE/2, Room.ROOM_HEIGHT/2, Room.TILE/2); // to center wall on tile

    return wall;
  }


  Obstacle pot() {
    PShape model = loadShape("resources/pot/pot.obj");
    model.scale(80, -80, 80);
    Obstacle obstacle = new Obstacle(model, true, loadImage("resources/pot/pot.png"), false, "Jarrón", "");

    obstacle.set_offset(Room.TILE/2, -20, Room.TILE/2); // to center object on tile
    return obstacle;
  }
}
