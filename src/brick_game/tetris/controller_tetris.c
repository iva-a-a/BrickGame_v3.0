#include "controller_tetris.h"

void tetris_userInput(UserAction_t action, bool hold) {
    (void)hold;
    Game_tetris *tetris = get_ptr_game_tetris();
    fsm(tetris, action);
}

GameInfo_t tetris_updateCurrentState() {
  Game_tetris *tetris = get_ptr_game_tetris();

  if (!tetris->is_init) {
    setup_game(tetris);
    tetris->is_init = true;
  }

  update_game(tetris);

  free_matrix(tetris->render_field, ROWS_BOARD);
  tetris->render_field = build_render_field(tetris);

  GameInfo_t info = (GameInfo_t){0};
  info.field = tetris->render_field;
  info.next = tetris->next;
  info.score = tetris->score;
  info.high_score = tetris->high_score;
  info.level = tetris->level;
  info.speed = tetris->speed;
  info.pause = (tetris->state == Break);

  return info;
}
