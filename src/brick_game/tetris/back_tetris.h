#ifndef BACK_TETRIS_H
#define BACK_TETRIS_H

#include <stdbool.h>

#include "../defines.h"
#include "../struct.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  int **field;
  int **next;
  int **now;
  int x;
  int y;
  int number_now_f;
  int number_next_f;
  long long int prev_time;
  int score;
  int high_score;
  int level;
  int speed;
  GameState_t state;

  bool is_init;
  GameInfo_t info;

  int **render_field;
} Game_tetris;

void setup_game(Game_tetris *tetris);

void fsm(Game_tetris *tetris, UserAction_t action);
Game_tetris *get_ptr_game_tetris();
void update_game(Game_tetris *tetris);

void build_render_field_inplace(Game_tetris *tetris);

#ifdef __cplusplus
}
#endif

#endif
