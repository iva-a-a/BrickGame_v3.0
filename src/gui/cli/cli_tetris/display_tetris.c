#include "display_tetris.h"

static void print_stats_tetris() {
  mvprintw(0, 27, "NEXT");
  mvprintw(20, 24, "SPACE - rotate");
}

static void draw_matrix_blocks(int **matrix, int rows, int cols,
                               int top, int left,
                               bool clear_area) {
  if (!matrix) {
    return;
  }
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int y = top + i;
      int x = left + j * 2;

      if (clear_area) {
        mvprintw(y, x, "  ");
      }
      if (matrix[i][j] != 0) {
        mvprintw(y, x, "[]");
      }
    }
  }
}

static void draw_frame(GameInfo_t info, bool draw_next) {
  print_game_board();
  print_stats_ban();
  print_stats_tetris();
  print_stats(info.level, info.speed, info.score, info.high_score, 1000);

  draw_matrix_blocks(info.field, ROWS_BOARD, COL_BOARD, 1, 1, false);

  if (draw_next) {
    draw_matrix_blocks(info.next, ROWS_FIGURE - 1, COL_FIGURE, 2, 25, true);
  }
}

static bool wait_restart_or_exit() {
  while (1) {
    UserAction_t action = input_key();
    if (action == Terminate) return false;
    if (action == Start) return true;
  }
}

static void printCurrentState(GameInfo_t info) {
  if (!info.field) return;

  if (info.pause) {
    print_pause();
  } else {
    draw_frame(info, true);
  }
  refresh();
}

static bool gameover_screen_and_wait(GameInfo_t info) {
  if (info.field) {
    draw_frame(info, false);
  } else {
    print_game_board();
  }
  print_game_over();
  refresh();
  return wait_restart_or_exit();
}

void game_tetris(void) {
  print_start();
  refresh();
  while (1) {
    UserAction_t a = input_key();
    if (a == Start) break;
  }

  tetris_userInput(Start, false);

  while (1) {
    UserAction_t a = input_key();
    if (a != None) tetris_userInput(a, false);

    GameInfo_t info = tetris_updateCurrentState();

    if (info.next == NULL) {
      bool restart = gameover_screen_and_wait(info);
      if (!restart) {
        tetris_userInput(Terminate, false);
        return;
      }
      tetris_userInput(Start, false);
      continue;
    }

    printCurrentState(info);
  }
}
