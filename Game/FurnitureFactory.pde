class ObstacleFactory {

  Obstacle createWall() {
    Obstacle wall = new Obstacle(createShape(BOX, Room.TILE, 800, Room.TILE));
    wall.set_offset(Room.TILE/2, Room.TILE/2); // to center wall on tile
    return wall;
  }
}
