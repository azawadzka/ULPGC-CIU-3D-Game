void createGameObjects() {

  Furniture a = furnitureFactory.createWall(4, 3);
  board.put_on_board(a, a.p, a.r);
}
