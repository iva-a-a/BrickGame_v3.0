#include "back_tetris.h"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static void gen_rand_figure(Game_tetris *tetris) {
  int figs[TETRIS_F][ROWS_FIGURE][COL_FIGURE] = FIGURES;
  int num = rand() % TETRIS_F;
  for (int i = 0; i < ROWS_FIGURE; i++) {
    for (int j = 0; j < COL_FIGURE; j++) {
      tetris->next[i][j] = figs[num][i][j];
    }
  }
  tetris->number_next_f = num;
}

static bool collision(Game_tetris *tetris) {
  bool is_col = false;
  for (int i = 0; i < ROWS_FIGURE; i++) {
    for (int j = 0; j < COL_FIGURE; j++) {
      if (tetris->now[i][j] != 0) {
        int x = tetris->x + j, y = tetris->y + i;
        if (x < 0 || x >= COL_BOARD || y >= ROWS_BOARD || y < 0) {
          is_col = true;
        } else if (tetris->field[y][x] != 0) {
          is_col = true;
        }
      }
    }
  }
  return is_col;
}

static void fall_figure(Game_tetris *tetris) {
  long long int time = time_in_millisec();
  if (time - tetris->prev_time > tetris->speed) {
    tetris->y++;
    if (collision(tetris)) {
      tetris->y--;
      tetris->state = Attaching;
    }
    tetris->prev_time = time;
  }
}

static void rotate_figure(Game_tetris *tetris) {
  if (tetris->number_now_f != 3) {
    int size;
    if (tetris->number_now_f == 0) {
      size = 4;
    } else {
      size = 3;
    }
    int tmp[size][size];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        tmp[j][i] = tetris->now[i][j];
      }
    }
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        tetris->now[i][j] = tmp[i][size - j - 1];
      }
    }
    if (collision(tetris)) {
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          tetris->now[j][i] = tmp[i][j];
        }
      }
    }
  }
}

static void move_figure(Game_tetris *tetris, UserAction_t key) {
  if (key == Left) {
    tetris->x--;
    if (collision(tetris)) {
      tetris->x++;
    }
  } else if (key == Right) {
    tetris->x++;
    if (collision(tetris)) {
      tetris->x--;
    }
  } else if (key == Down) {
    while (!collision(tetris)) {
      tetris->y++;
    }
    tetris->y--;
  }
}

static void scoring_points(Game_tetris *tetris, int count) {
  if (count == 1) {
    tetris->score += SCORE_1;
  } else if (count == 2) {
    tetris->score += SCORE_2;
  } else if (count == 3) {
    tetris->score += SCORE_3;
  } else if (count == 4) {
    tetris->score += SCORE_4;
  }
}

static void increase_level(Game_tetris *tetris) {
  while (tetris->score >= tetris->level * LEVEL_NEXT &&
         tetris->level != MAX_LEVEL) {
    if (tetris->level < MAX_LEVEL) {
      tetris->level++;
      tetris->speed -= 100;
    }
  }
}

static int remove_row(Game_tetris *tetris) {
  int full_row = ROWS_BOARD - 1;
  int count = 0;
  for (int i = ROWS_BOARD - 1; i >= 0; i--) {
    bool is_full = true;
    for (int j = 0; j < COL_BOARD; j++) {
      if (tetris->field[i][j] == 0) {
        is_full = false;
      }
    }
    if (is_full == false) {
      full_row--;
    } else {
      count++;
      for (int k = full_row; k > 0; k--) {
        for (int j = 0; j < COL_BOARD; j++) {
          tetris->field[k][j] = tetris->field[k - 1][j];
          tetris->field[k - 1][j] = 0;
        }
      }
      i++;
    }
  }
  return count;
}

static void save_high_score(Game_tetris *tetris) {
  if (tetris->score >= tetris->high_score) {
    tetris->high_score = tetris->score;
    FILE *highScore;
    highScore = fopen("highscore_tetris.txt", "w");
    if (highScore) {
      fprintf(highScore, "%d", tetris->high_score);
      fclose(highScore);
    }
  }
}

static void clear_mat(int **matrix, int x, int y) {
  for (int i = 0; i < x; i++) {
    for (int j = 0; j < y; j++) {
      matrix[i][j] = 0;
    }
  }
}

static void clearing_game(Game_tetris *tetris) {
  clear_mat(tetris->field, ROWS_BOARD, COL_BOARD);
  clear_mat(tetris->next, ROWS_FIGURE, COL_FIGURE);
  clear_mat(tetris->now, ROWS_FIGURE, COL_FIGURE);
  clear_mat(tetris->render_field, ROWS_BOARD, COL_BOARD);

  tetris->score = 0;
  tetris->level = 1;
  tetris->speed = 1000;

  tetris->x = COL_BOARD / 2 - COL_FIGURE / 2;
  tetris->y = 0;
  tetris->state = Begin;

  gen_rand_figure(tetris);
}

static void initial_info(Game_tetris *tetris) {
  tetris->field = (int **)malloc(sizeof(int *) * ROWS_BOARD);
  for (int i = 0; i < ROWS_BOARD; i++) {
    tetris->field[i] = (int *)malloc(sizeof(int) * COL_BOARD);
  }
  tetris->next = (int **)malloc(sizeof(int *) * ROWS_FIGURE);
  for (int i = 0; i < ROWS_FIGURE; i++) {
    tetris->next[i] = (int *)malloc(sizeof(int) * COL_FIGURE);
  }
  tetris->now = (int **)malloc(sizeof(int *) * ROWS_FIGURE);
  for (int i = 0; i < ROWS_FIGURE; i++) {
    tetris->now[i] = (int *)malloc(sizeof(int) * COL_FIGURE);
  }
  tetris->render_field = (int **)malloc(sizeof(int *) * ROWS_BOARD);
  for (int i = 0; i < ROWS_BOARD; i++) {
    tetris->render_field[i] = (int *)malloc(sizeof(int) * COL_BOARD);
  }

  clearing_game(tetris);
  FILE *highScore;
  highScore = fopen("highscore_tetris.txt", "r");
  if (highScore) {
    if (fscanf(highScore, "%d", &tetris->high_score) == 0) {
      tetris->high_score = 0;
    }
    fclose(highScore);
  } else {
    tetris->high_score = 0;
    save_high_score(tetris);
  }
}

static void free_matrix(int **arr, int rows) {
  if (arr) {
    for (int i = 0; i < rows; i++) {
      free(arr[i]);
    }
    free(arr);
  }
}

static void free_info(Game_tetris *tetris) {
  free_matrix(tetris->field, ROWS_BOARD);
  free_matrix(tetris->next, ROWS_FIGURE);
  free_matrix(tetris->now, ROWS_FIGURE);
  free_matrix(tetris->render_field, ROWS_BOARD);
}

static void copy_figures(Game_tetris *tetris) {
  for (int i = 0; i < ROWS_FIGURE; i++) {
    for (int j = 0; j < COL_FIGURE; j++) {
      tetris->now[i][j] = tetris->next[i][j];
    }
  }
  tetris->number_now_f = tetris->number_next_f;
}

static void filling_field(Game_tetris *tetris) {
  for (int i = 0; i < ROWS_FIGURE; i++) {
    for (int j = 0; j < COL_FIGURE; j++) {
      if (tetris->y + i >= 0 && tetris->x + j >= 0 && tetris->now[i][j] == 1) {
        tetris->field[tetris->y + i][tetris->x + j] = tetris->number_now_f + 1;
      }
    }
  }
}

void setup_game(Game_tetris *tetris) {
  srand((unsigned int)time(NULL));
  initial_info(tetris);
}

void update_game(Game_tetris *tetris) {
  if (tetris->state == Begin) {
    return;
  }

  if (tetris->state == Generation) {
    tetris->x = COL_BOARD / 2 - COL_FIGURE / 2;
    tetris->y = 0;
    tetris->prev_time = time_in_millisec();
    copy_figures(tetris);
    gen_rand_figure(tetris);

    if (!collision(tetris)) tetris->state = Falling;
    else tetris->state = End;

  } else if (tetris->state == Falling) {
    fall_figure(tetris);

  } else if (tetris->state == Moving_down) {
    move_figure(tetris, Down);
    tetris->state = Falling;

  } else if (tetris->state == Moving_left) {
    move_figure(tetris, Left);
    tetris->state = Falling;

  } else if (tetris->state == Moving_right) {
    move_figure(tetris, Right);
    tetris->state = Falling;

  } else if (tetris->state == Moving_rotate) {
    rotate_figure(tetris);
    tetris->state = Falling;

  } else if (tetris->state == Attaching) {
    filling_field(tetris);
    scoring_points(tetris, remove_row(tetris));
    increase_level(tetris);
    save_high_score(tetris);
    tetris->state = Generation;
  }
}

void fsm(Game_tetris *tetris, UserAction_t action) {
  if (tetris->state == Begin) {
    if (action == Start) {
      clearing_game(tetris);
      tetris->state = Generation;
    } else if (action == Terminate) {
      tetris->state = Exit;
    }
    return;
  }

  if (tetris->state == Falling) {
    if (action == Pause) {
      tetris->state = Break;
    } else if (action == Left) {
      tetris->state = Moving_left;
    } else if (action == Right) {
      tetris->state = Moving_right;
    } else if (action == Down) {
      tetris->state = Moving_down;
    } else if (action == Action) {
      tetris->state = Moving_rotate;
    } else if (action == Terminate) {
      tetris->state = End;
    }
    return;
  }
  if (tetris->state == Break) {
    if (action == Pause) {
      tetris->state = Falling;
    } else if (action == Terminate) {
      tetris->state = End;
    }
    return;
  }
  if (tetris->state == End) {
    if (action == Start) {
      clearing_game(tetris);
      tetris->state = Generation;
    } else if (action == Terminate) {
      tetris->state = Begin;
    }

  return;
  }
}

Game_tetris *get_ptr_game_tetris() {
  static Game_tetris tetris = {0};
  return &tetris;
}

void build_render_field_inplace(Game_tetris *tetris) {
  if (!tetris || !tetris->field || !tetris->now || !tetris->render_field) return;

  for (int i = 0; i < ROWS_BOARD; i++)
    for (int j = 0; j < COL_BOARD; j++)
        tetris->render_field[i][j] = tetris->field[i][j];
  for (int i = 0; i < ROWS_FIGURE; i++) {
    for (int j = 0; j < COL_FIGURE; j++) {
      if (tetris->now[i][j] == 0) continue;
      int fy = tetris->y + i;
      int fx = tetris->x + j;
      if (fy >= 0 && fy < ROWS_BOARD && fx >= 0 && fx < COL_BOARD) {
          tetris->render_field[fy][fx] = tetris->number_now_f + 1;
      }
    }
  }
}
