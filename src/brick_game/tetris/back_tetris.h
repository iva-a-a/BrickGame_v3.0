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
} Game_tetris;

GameInfo_t *get_GameInfo();

void setup_game(Game_tetris *tetris);

void initial_info(Game_tetris *tetris);

void free_info(Game_tetris *tetris);

void gen_rand_figure(Game_tetris *tetris);

void filling_field(Game_tetris *tetris);

int remove_row(Game_tetris *tetris);

void fall_figure(Game_tetris *tetris);

void rotate_figure(Game_tetris *tetris);

void move_figure(Game_tetris *tetris, UserAction_t key);

int collision(Game_tetris *tetris);

void copy_figures(Game_tetris *tetris);

void scoring_points(Game_tetris *tetris, int count);

void increase_level(Game_tetris *tetris);

void save_high_score(Game_tetris *tetris);

void clear_mat(int **matrix, int x, int y);

void clearing_game(Game_tetris *tetris);

void update_game(Game_tetris *tetris);

int **convert_matrix(int **arr1, int row, int col, int x, int y);

void set_color_third_elem(int **arr, int color);

int **join_matrix(int **arr1, int **arr2);

void free_matrix(int **arr);

void free_gameinfo(GameInfo_t *info);

#ifdef __cplusplus
}
#endif

#endif
