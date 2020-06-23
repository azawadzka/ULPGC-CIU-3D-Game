
class BoardFactory {

  /*Level 1: 8x8 board
   Item to pick: 8 , 3
   Ending level: 8 , 8
   */
  private Board create_board1() {
    Board board = new Board(8, 8, 7, 7);

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
    board.put_on_board(obstacleFactory.venus(), 3, 0);

    return board;
  }

  private Board create_board2() {
    Board board = new Board(9, 9, 8, 4);

    board.put_on_board(obstacleFactory.createWall(), 8, 7);
    board.put_on_board(obstacleFactory.createWall(), 7, 7);
    board.put_on_board(obstacleFactory.createWall(), 7, 6);
    board.put_on_board(obstacleFactory.createWall(), 6, 6);
    board.put_on_board(obstacleFactory.createWall(), 7, 5);
    board.put_on_board(obstacleFactory.createWall(), 5, 5);
    board.put_on_board(obstacleFactory.createWall(), 5, 3);
    board.put_on_board(obstacleFactory.createWall(), 7, 3);
    board.put_on_board(obstacleFactory.createWall(), 6, 2);
    board.put_on_board(obstacleFactory.createWall(), 7, 2);
    board.put_on_board(obstacleFactory.createWall(), 7, 1);
    board.put_on_board(obstacleFactory.createWall(), 8, 1);
    board.put_on_board(obstacleFactory.pot(), 4, 7);
    board.put_on_board(obstacleFactory.pot(), 2, 6);
    board.put_on_board(obstacleFactory.pot(), 2, 2);
    board.put_on_board(obstacleFactory.pot(), 4, 1);
    board.put_on_board(obstacleFactory.key(), 8, 0);
    board.put_on_board(obstacleFactory.flamethrower(), 8, 8);
    board.put_on_board(obstacleFactory.door(), 6, 4);
    board.put_on_board(obstacleFactory.spider(), 4, 4);
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
