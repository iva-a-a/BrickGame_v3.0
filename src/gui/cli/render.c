#include "render.h"
#include "../../brick_game/defines.h"

void print_game_setection() {
  mvprintw(1, 7, "BRICK_GAME v2.0");
  mvprintw(3, 1, "TETRIS - press \'T\' or \'t\' to START");
  mvprintw(4, 1, "SNAKE  - press \'S\' or \'s\' to START");
  mvprintw(5, 1, "EXIT   - press \'Esc\'");
}

void clear_screen() {
  for (int i = 0; i < 30; i++) {
    for (int j = 0; j < 50; j++) {
      mvprintw(i, j, " ");
    }
  }
}

void print_game_board() {
  for (int i = 0; i < ROWS_BOARD + 2; i++) {
    for (int j = 0; j < (COL_BOARD + 2) * 2; j++) {
      if (i == 0 || i == ROWS_BOARD + 1) {
        if (j < (COL_BOARD + 2) * 2 - 2) {
          mvaddch(i, j, '.');
        } else {
          mvaddch(i, j, ' ');
        }
      } else if (j == 0 || j == (COL_BOARD + 1) * 2 - 1) {
        mvaddch(i, j, '.');
      } else if (j % 2 == 0) {
        mvaddch(i, j, ' ');
      } else {
        mvaddch(i, j, ' ');
      }
    }
  }
  mvprintw(10, 13, "%*c", 8, ' ');
}

void print_start() {
  for (int i = 0; i < 25; i++) {
    if (i != 10) {
      mvprintw(i, 0, "%*c", 80, ' ');
    }
  }
  mvprintw(10, 0, " Press ENTER to START%*c", 59, ' ');
}

void print_stats_ban() {
  mvprintw(5, 27, "LEVEL");
  mvprintw(8, 27, "SPEED");
  mvprintw(11, 27, "SCORE");
  mvprintw(14, 27, "HIGH SCORE");
  mvprintw(17, 24, "ESC - exit");
  mvprintw(18, 24, "\'P\' - pause");
  mvprintw(19, 24, "ARROWS - move");
  mvprintw(20, 24, "SPACE - action");
  mvprintw(21, 24, "%*c", 20, ' ');
}

void print_pause() {
  mvprintw(9, 0, "%*c", 22, ' ');
  mvprintw(10, 0, "        PAUSE         ");
  mvprintw(11, 0, "%*c", 22, ' ');
}

void print_game_over() {
  mvprintw(9, 0, "%*c", 22, ' ');
  mvprintw(10, 0, "      GAME OVER!      ");
  mvprintw(11, 0, "%*c", 22, ' ');
  mvprintw(21, 24, "ENTER - restart");
}

void print_stats(int level, int speed, int score, int high_score,
                 int begin_speed) {
  mvprintw(6, 29, "%-5d", level);
  mvprintw(9, 29, "%-5.2f", (float)begin_speed / speed);
  mvprintw(12, 29, "%-10d", score);
  mvprintw(15, 29, "%-10d", high_score);
}
