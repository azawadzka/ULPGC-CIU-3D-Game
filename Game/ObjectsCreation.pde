void createGameObjects() {

  Thing a = thingFactory.createWall(4, 3);
  board.put_on_board(a, a.p, a.r, 2, 3);
}
