class MonsterFactory {

  Monster create_monster_for_level(int level, Board board) {
    Monster monster = null;

    switch(level) {
    case 1:
      monster = create_ant(board, 6, 4);
      break;
    case 2:
      monster = create_ant(board, 4, 3);
      break;
    }

    return monster;
  }

  Monster create_ant(Board board, int init_p, int init_r) {
    assert(board.is_free(init_p, init_r));
    PShape monster_model = loadShape("resources/ant/ant1.obj");
    monster_model.scale(60, -60, 60);
    Monster monster = new Monster(AI_Type.RANDOM, board, init_p, init_r, monster_model);
    monster.set_offset(Room.TILE/2, 0, Room.TILE/2); // to center object on tile
    return monster;
  }
}
