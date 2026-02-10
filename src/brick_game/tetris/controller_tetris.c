#include "controller_tetris.h"

void tetris_userInput(UserAction_t action, bool hold) {
  (void)hold;
  Game_tetris *tetris = get_ptr_game_tetris();
  ensure_init_and_free(tetris);

  fsm(tetris, action);
}

GameInfo_t tetris_updateCurrentState() {
  Game_tetris *tetris = get_ptr_game_tetris();

  ensure_init_and_free(tetris);

  update_game(tetris);

  build_render_field_inplace(tetris);

  GameInfo_t info = (GameInfo_t){0};
  info.field = tetris->render_field;
  info.score = tetris->score;
  info.high_score = tetris->high_score;
  info.level = tetris->level;
  info.speed = tetris->speed;
  info.pause = (tetris->state == Break);
  info.next = (tetris->state == End) ? NULL : tetris->next;

  return info;
}

