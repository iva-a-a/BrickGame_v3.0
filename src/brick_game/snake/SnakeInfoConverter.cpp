//
//  SnakeInfoConverter.cpp
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//

#include "SnakeInfoConverter.h"
#include "../defines.h"

#define BASE_UI_SPEED 1000
#define BASE_SNAKE_SPEED 500

static int  g_field_buf[ROWS_BOARD][COL_BOARD];
static int* g_field_rows[ROWS_BOARD];
static bool g_inited = false;

static void ensure_buffers() {
  if (g_inited) return;
  for (int i = 0; i < ROWS_BOARD; ++i) g_field_rows[i] = g_field_buf[i];
  g_inited = true;
}

static void clear_field() {
  for (int i = 0; i < ROWS_BOARD; ++i)
    for (int j = 0; j < COL_BOARD; ++j)
      g_field_buf[i][j] = 0;
}

GameInfo_t SnakeInfoConverter::toGameInfo(const SnakeInfo& info) {
    ensure_buffers();
    clear_field();
    listToArray(info.snake);
    coordinateToArray(info.apple);
    
    GameInfo_t out{};

    out.score = info.score;
    out.high_score = info.high_score;
    out.level = info.level;
    out.speed = info.speed * (BASE_UI_SPEED / BASE_SNAKE_SPEED);
    out.pause = info.state == Break;
    out.next = (info.state == End) ? nullptr : g_field_rows;
    out.field = g_field_rows;

    return out;
}

void SnakeInfoConverter::listToArray(const std::list<Coordinate>& l) {
    for (const auto& c : l) {
      if (c.y >= 0 && c.y < ROWS_BOARD && c.x >= 0 && c.x < COL_BOARD)
        g_field_buf[c.y][c.x] = 1;
    }
}

void SnakeInfoConverter::coordinateToArray(Coordinate c) {
    if (c.y >= 0 && c.y < ROWS_BOARD && c.x >= 0 && c.x < COL_BOARD)
       g_field_buf[c.y][c.x] = 1;
}
