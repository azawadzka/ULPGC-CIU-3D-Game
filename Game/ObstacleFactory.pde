class ObstacleFactory {

  Obstacle createWall() {
    Obstacle wall = new Obstacle(createShape(BOX, Room.TILE, Room.ROOM_HEIGHT, Room.TILE),false,null);
    wall.set_offset(Room.TILE/2, Room.ROOM_HEIGHT/2, Room.TILE/2); // to center wall on tile
    return wall;
  }
  
  Obstacle bomb() {
    PShape bombModel = loadShape("resources/bomb/model.obj");
    bombModel.scale(25,-25,25);
    Obstacle bombObstacle = new Obstacle(bombModel,true,loadImage("resources/bomb/bomb.png"));
    bombObstacle.set_offset(Room.TILE/2, 0, Room.TILE/2); // to center object on tile
    return bombObstacle;
  }
  
  Obstacle pot() {
    PShape model = loadShape("resources/pot/pot.obj");
    model.scale(80,-80,80);
    Obstacle obstacle = new Obstacle(model,true,loadImage("resources/pot/pot.png"));
    obstacle.set_offset(Room.TILE/2, -20, Room.TILE/2); // to center object on tile
    return obstacle;
  }
}
