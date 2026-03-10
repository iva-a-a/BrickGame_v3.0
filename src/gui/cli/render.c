#include "render.h"
#include <ncurses.h>

#include "../../brick_game/defines.h"

void print_game_selection(AvailableGames_t games) {
  clear();
  mvprintw(1, 7, "BRICK_GAME v3.0");
  mvprintw(3, 1, "Choose game:");

  for (int i = 0; i < games.count; i++) {
    mvprintw(5 + i, 1, "%d - %s", i + 1, games.items[i].name);
  }

  mvprintw(7 + games.count, 1, "ESC - exit");
  refresh();
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

void print_stats(int level, int speed, int score, int high_score) {
  mvprintw(6, 29, "%-5d", level);
  mvprintw(9, 29, "%-5.2f", (float)1000 / speed);
  mvprintw(12, 29, "%-10d", score);
  mvprintw(15, 29, "%-10d", high_score);
}
