#include "render_logic.h"
#include "../../brick_game/api/apiBG.h"
#include "../../brick_game/defines.h"
#include "display.h"
#include "render.h"

static void draw_matrix_blocks(int **matrix, int rows, int cols, int top,
                               int left, bool clear_area) {
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
  print_stats(info.level, info.speed, info.score, info.high_score);

  draw_matrix_blocks(info.field, ROWS_BOARD, COL_BOARD, 1, 1, false);

  if (draw_next) {
    draw_matrix_blocks(info.next, ROWS_FIGURE, COL_FIGURE, 1, 25, true);
  }
}

static bool wait_restart_or_exit() {
  while (1) {
    UserAction_t action = input_key();
    if (action == Terminate) {
      return false;
    }
    if (action == Start) {
      return true;
    }
  }
}

static void printCurrentState(GameInfo_t info, bool drawNext) {
  if (!info.field) {
    return;
  }
  if (info.pause) {
    print_pause();
  } else {
    draw_frame(info, drawNext);
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

void print_game() {
  print_start();
  refresh();
  while (1) {
    UserAction_t a = input_key();
    if (a == Start) {
      break;
    }
  }

  userInput(Start, false);

  while (1) {
    UserAction_t a = input_key();
    if (a != None) {
      userInput(a, false);
    }

    GameInfo_t info = updateCurrentState();

    if (info.next == NULL) {
      bool restart = gameover_screen_and_wait(info);
      if (!restart) {
        userInput(Terminate, false);
        return;
      }
      userInput(Start, false);
      continue;
    }
    // рисуется next всегда
    printCurrentState(info, true);
  }
}
