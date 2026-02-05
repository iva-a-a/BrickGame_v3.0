#ifndef DISPLAY_TETRIS_H
#define DISPLAY_TETRIS_H

#include "../../../brick_game/tetris/controller_tetris.h"
#include "../display.h"

#ifdef __cplusplus
extern "C" {
#endif

void print_stats_tetris();

void print_fallfigure(int **arr, int row, int col);

void clear_next_figure();

void printCurrentState(GameInfo_t *info);

void game_tetris();

#ifdef __cplusplus
}
#endif

#endif
