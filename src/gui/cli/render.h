#ifndef RENDER_H
#define RENDER_H

#include <ncurses.h>

#include "../../brick_game/struct.h"

#ifdef __cplusplus
extern "C" {
#endif

void print_game_setection();
void clear_screen();
void print_game_board();
void print_stats_ban();
void print_start();
void print_pause();
void print_game_over();
void print_stats(int level, int speed, int score, int high_score,
                 int begin_speed);

#ifdef __cplusplus
}
#endif

#endif
