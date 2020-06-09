
class BoardFactory {

  /*Level 1: 8x8 board
             Item to pick: 8 , 3
             Ending level: 8 , 8
  */
private Board create_board1() {
  Board board = new Board(8);

  board.put_on_board(obstacleFactory.createWall(), 3, 2);
  board.put_on_board(obstacleFactory.createWall(), 3, 3);
  board.put_on_board(obstacleFactory.createWall(), 4, 2);
  board.put_on_board(obstacleFactory.createWall(), 4, 3);
  
  board.put_on_board(obstacleFactory.createWall(), 7, 6);
  board.put_on_board(obstacleFactory.createWall(), 6, 6);
  board.put_on_board(obstacleFactory.createWall(), 5, 6);
  board.put_on_board(obstacleFactory.createWall(), 4, 6);
  board.put_on_board(obstacleFactory.destructiveWall(), 4, 7);

  board.put_on_board(obstacleFactory.bomb(), 7, 3);
  board.put_on_board(obstacleFactory.pot(), 2, 4);
  
  board.ending_level(7,7);

  return board;
}

private Board create_board2() {
  Board board = new Board(4);
  
  board.ending_level(3,3);

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
