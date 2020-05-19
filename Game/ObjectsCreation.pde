void createGameObjects() {

  board.put_on_board(obstacleFactory.createWall(), 4, 3);
  board.put_on_board(obstacleFactory.createWall(), 4, 4);
  board.put_on_board(obstacleFactory.createWall(), 5, 4);
}
