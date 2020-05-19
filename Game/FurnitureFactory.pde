class FurnitureFactory {

  Furniture createWall(int p, int r) {
    Furniture wall = new Furniture(createShape(BOX, Room.TILE, 800, Room.TILE), p, r);
    wall.set_offset(Room.TILE/2, Room.TILE/2); // to center wall on tile
    return wall;
  }
}
