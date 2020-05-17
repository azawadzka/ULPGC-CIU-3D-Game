class ThingFactory {

  Thing createWall(int p, int r) {
    return new Thing(createShape(BOX, Room.TILE, 800, Room.TILE), p, r);
  }
}
