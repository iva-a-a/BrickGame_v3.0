#ifndef DISPLAY_H
#define DISPLAY_H

#include <ncurses.h>

#include "../../brick_game/tetris/back_tetris.h"

#ifdef __cplusplus
extern "C" {
#endif

void setup_gui();
void delete_gui();

UserAction_t input_key();

void print_game_setection();

void clear_screen();
void print_game_board();
void print_stats_ban();
void print_start();
void print_pause();
void print_game_over();
void print_stats(int level, int speed, int score, int high_score,
                 int begin_speed);

void print_arr(int **arr);

#ifdef __cplusplus
}
#endif

#endif
