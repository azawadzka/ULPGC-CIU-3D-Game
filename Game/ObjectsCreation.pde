void createGameObjects() {

  Furniture a = furnitureFactory.createWall(4, 3);
  board.put_on_board(a, a.p, a.r);
  Furniture b = furnitureFactory.createWall(4, 4);
  board.put_on_board(b, b.p, b.r);
  Furniture c = furnitureFactory.createWall(5, 4);
  board.put_on_board(c, c.p, c.r);
}
