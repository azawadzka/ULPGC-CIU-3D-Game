class ObstacleFactory {

  //Parameters: PShape s, boolean pick, PImage icon,boolean unlockable,String name,String requirement

  Obstacle createWall() {

    PShape shape = createShape(GROUP);
    shape.noStroke();
    PShape s1 = createShape(BOX, Room.TILE, Room.ROOM_HEIGHT / 3, Room.TILE); 
    s1.translate(0, -Room.ROOM_HEIGHT / 3, 0);
    shape.addChild(s1);
    PShape s2 = createShape(BOX, Room.TILE, Room.ROOM_HEIGHT / 3, Room.TILE); 
    shape.addChild(s2);
    PShape s3 = createShape(BOX, Room.TILE, Room.ROOM_HEIGHT / 3, Room.TILE); 
    s3.translate(0, Room.ROOM_HEIGHT / 3, 0);
    shape.addChild(s3);

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

    PShape shape = createShape(GROUP);
    shape.noStroke();
    PShape s1 = createShape(BOX, Room.TILE, Room.ROOM_HEIGHT / 3, Room.TILE); 
    s1.translate(0, -Room.ROOM_HEIGHT / 3, 0);
    shape.addChild(s1);
    PShape s2 = createShape(BOX, Room.TILE, Room.ROOM_HEIGHT / 3, Room.TILE); 
    shape.addChild(s2);
    PShape s3 = createShape(BOX, Room.TILE, Room.ROOM_HEIGHT / 3, Room.TILE); 
    s3.translate(0, Room.ROOM_HEIGHT / 3, 0);
    shape.addChild(s3);

    PImage tex = loadImage("resources/level" + 1 + "/wall_weak3.png");
    shape.setTexture(tex);
    Obstacle wall = new Obstacle(shape, false, null, true, "", "Bomb");
    wall.set_offset(Room.TILE/2, Room.ROOM_HEIGHT/2, Room.TILE/2); // to center wall on tile

    //fill(255, 0, 0);
    //fill(255);

    return wall;
  }

  Obstacle portal() {
    PShape model = loadShape("resources/portal/EeriePortal.obj");
    model.scale(45, -45, 45);
    model.rotateY(-HALF_PI); 
    Obstacle obstacle = new Obstacle(model, false, null, false, "portal", "");

    obstacle.set_offset(Room.TILE/2 - 95, -0, Room.TILE/2); // to center object on tile
    return obstacle;
  }

  Obstacle torch() {
    PShape model = loadShape("resources/torch/TikiTorch.obj");
    model.scale(45, -45, 45);
    Obstacle obstacle = new Obstacle(model, false, null, false, "torch", "");

    obstacle.set_offset(Room.TILE/2, -0, Room.TILE/2); // to center object on tile
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
    model.scale(2, -2, 2);
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
