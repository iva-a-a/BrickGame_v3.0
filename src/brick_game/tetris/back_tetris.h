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

void initial_info(Game_tetris *tetris);

void free_info(Game_tetris *tetris);

void clear_mat(int **matrix, int x, int y);

void clearing_game(Game_tetris *tetris);


void fsm(Game_tetris *tetris, UserAction_t action);

Game_tetris *get_ptr_game_tetris();

void update_game(Game_tetris *tetris);


void gen_rand_figure(Game_tetris *tetris);

void filling_field(Game_tetris *tetris);

int remove_row(Game_tetris *tetris);

void fall_figure(Game_tetris *tetris);

void rotate_figure(Game_tetris *tetris);

void move_figure(Game_tetris *tetris, UserAction_t key);

bool collision(Game_tetris *tetris);

void scoring_points(Game_tetris *tetris, int count);

void increase_level(Game_tetris *tetris);


void save_high_score(Game_tetris *tetris);


void copy_figures(Game_tetris *tetris);

int **build_render_field(Game_tetris *t);

void free_matrix(int **arr, int rows);

#ifdef __cplusplus
}
#endif

#endif
