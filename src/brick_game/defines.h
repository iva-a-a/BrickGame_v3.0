#ifndef DEFINES_H
#define DEFINES_H

#define ROWS_BOARD 20

#define COL_BOARD 10

#define ROWS_FIGURE 4

#define COL_FIGURE 4

#define TETRIS_F 7

#define SCORE_1 100

#define SCORE_2 300

#define SCORE_3 700

#define SCORE_4 1500

#define SCORE_WIN 200

#define LEVEL_NEXT 600

#define LEVEL_NEXT_SNAKE 5

#define MAX_LEVEL 10

#define FIGURES                                                                \
  {                                                                            \
    {{0, 0, 0, 0}, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0, 0, 0}},                  \
        {{1, 0, 0, 0}, {1, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},              \
        {{0, 0, 1, 0}, {1, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},              \
        {{0, 1, 1, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},              \
        {{0, 1, 1, 0}, {1, 1, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}},              \
        {{0, 1, 0, 0}, {1, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}}, {            \
      {1, 1, 0, 0}, {0, 1, 1, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}                   \
    }                                                                          \
  }

#endif
