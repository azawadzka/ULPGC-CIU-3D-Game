class BoardFactory {

private Board create_board1() {
  Board board = new Board(8);

  board.put_on_board(obstacleFactory.createWall(), 4, 3);
  board.put_on_board(obstacleFactory.createWall(), 4, 4);
  board.put_on_board(obstacleFactory.createWall(), 5, 4);

  board.put_on_board(obstacleFactory.bomb(), 2, 2);
  board.put_on_board(obstacleFactory.pot(), 4, 6);

  return board;
}

private Board create_board2() {
  Board board = new Board(4);

  board.put_on_board(obstacleFactory.createWall(), 1, 1);

  board.put_on_board(obstacleFactory.pot(), 2, 2);

  return board;
}

Board create_board_for_level(int level) {

  Board board = null;

  switch(level) {
  case 1: 
    board = create_board1();
    break;
  case 2: 
    board = create_board2();
    break;
  }

  return board;
}

}
