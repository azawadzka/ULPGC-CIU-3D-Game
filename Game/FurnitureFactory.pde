class ObstacleFactory {

  Obstacle createWall() {
    Obstacle wall = new Obstacle(createShape(BOX, Room.TILE, Room.ROOM_HEIGHT, Room.TILE));
    wall.set_offset(Room.TILE/2, Room.ROOM_HEIGHT/2, Room.TILE/2); // to center wall on tile
    return wall;
  }
}
