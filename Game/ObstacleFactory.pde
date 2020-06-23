class ObstacleFactory {

  //Parameters: PShape s, boolean pick, PImage icon,boolean unlockable,String name,String requirement

  Obstacle createWall() {

    PShape shape = createShape(BOX, Room.TILE, Room.ROOM_HEIGHT, Room.TILE);
    PImage tex = loadImage("resources/level" + 1 + "/wall.png");
    shape.setTexture(tex);
    Obstacle wall = new Obstacle(shape, false, null, false, "0", "0");
    wall.set_offset(Room.TILE/2, Room.ROOM_HEIGHT/2, Room.TILE/2); // to center wall on tile
    return wall;
  }

  Obstacle bomb() {
    PShape bombModel = loadShape("resources/bomb/model.obj");
    bombModel.scale(25, -25, 25);
    Obstacle bombObstacle = new Obstacle(bombModel, true, loadImage("resources/bomb/bomb.png"), false, "Bomb", "");
    bombObstacle.set_offset(Room.TILE/2, 0, Room.TILE/2); // to center object on tile
    return bombObstacle;
  }

  Obstacle destructiveWall() {   

    PShape shape = createShape(BOX, Room.TILE, Room.ROOM_HEIGHT, Room.TILE);
    PImage tex = loadImage("resources/level" + 1 + "/wall_weak3.png");
    shape.setTexture(tex);
    Obstacle wall = new Obstacle(shape, false, null, true, "", "Bomb");
    wall.set_offset(Room.TILE/2, Room.ROOM_HEIGHT/2, Room.TILE/2); // to center wall on tile

    //fill(255, 0, 0);
    //fill(255);

    return wall;
  }


  Obstacle pot() {
    PShape model = loadShape("resources/pot/pot.obj");
    model.scale(80, -80, 80);
    Obstacle obstacle = new Obstacle(model, false, loadImage("resources/pot/pot.png"), false, "pot", "");

    obstacle.set_offset(Room.TILE/2, -20, Room.TILE/2); // to center object on tile
    return obstacle;
  }

  Obstacle key() {
    PShape model = loadShape("resources/key/Key.obj");
    model.scale(80, -80, 80);
    Obstacle obstacle = new Obstacle(model, true, loadImage("resources/key/key.png"), false, "Key", "");
    model.rotateY(1.6);
    obstacle.set_offset(Room.TILE/2, -20, Room.TILE/2); // to center object on tile
    return obstacle;
  }
  Obstacle door() {
    PShape model = loadShape("resources/door/Door.obj");
    model.scale(15, -10, 10);
    model.rotateY(1.6);
    Obstacle obstacle = new Obstacle(model, false, null, true, "", "Key");

    obstacle.set_offset(0, 0, Room.TILE/2); // to center object on tile
    return obstacle;
  }
  Obstacle spider() {
    PShape model = loadShape("resources/spider/skSpiderLargeMesh.obj");
    model.scale(3, -3, 3);
    Obstacle obstacle = new Obstacle(model, false, null, true, "", "Flamethrower");

    obstacle.set_offset(Room.TILE/2, -20, Room.TILE/2); // to center object on tile
    return obstacle;
  }
  Obstacle flamethrower() {
    PShape model = loadShape("resources/flamethrower/Flamethrower.obj");
    model.scale(1, -1, 1);
    Obstacle obstacle = new Obstacle(model, true, loadImage("resources/flamethrower/flame thrower.png"), false, "Flamethrower", "");

    obstacle.set_offset(Room.TILE/2, -20, Room.TILE/2); // to center object on tile
    return obstacle;
  }
}
