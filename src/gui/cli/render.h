#ifndef RENDER_H
#define RENDER_H

#ifdef __cplusplus
extern "C" {
#endif

void print_game_selection();
void clear_screen();
void print_game_board();
void print_stats_ban();
void print_start();
void print_pause();
void print_game_over();
void print_stats(int level, int speed, int score, int high_score);

#ifdef __cplusplus
}
#endif

#endif
