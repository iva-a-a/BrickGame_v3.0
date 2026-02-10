//
//  SnakeInfoConverter.cpp
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//

#include "SnakeInfoConverter.h"
#include "../defines.h"

static constexpr int MAX_SNAKE = ROWS_BOARD * COL_BOARD;

static int  g_snake_buf[MAX_SNAKE + 1][3];
static int* g_snake_rows[MAX_SNAKE + 1];

static int  g_apple_buf[2][3];
static int* g_apple_rows[2];

static bool g_inited = false;

static void ensure_buffers() {
    if (g_inited) return;

    for (int i = 0; i < MAX_SNAKE + 1; ++i) {
        g_snake_rows[i] = g_snake_buf[i];
    }
    for (int i = 0; i < 2; ++i) {
        g_apple_rows[i] = g_apple_buf[i];
    }
    g_inited = true;
}

GameInfo_t SnakeInfoConverter::toGameInfo(const SnakeInfo& info) {
    ensure_buffers();

    GameInfo_t out{};

    out.score = info.score;
    out.high_score = info.high_score;
    out.level = info.level;
    out.speed = info.speed;

    if (info.score == 1000) {
        out.pause = 4;          // WIN
    } else if (info.state == Break) {
        out.pause = 1;          // PAUSE
    } else if (info.state == Begin) {
        out.pause = 2;          // START
    } else if (info.state == End) {
        out.pause = 3;          // GAME OVER
    } else if (info.state == Exit) {
        out.pause = 9;          // EXIT
    } else {
        out.pause = 0;          // RUNNING
    }
    out.next  = listToArray(info.snake);
    out.field = coordinateToArray(info.apple);

    return out;
}

int **SnakeInfoConverter::listToArray(const std::list<Coordinate>& l) {
    ensure_buffers();

    int idx = 0;
    for (const auto& c : l) {
        if (idx >= MAX_SNAKE) break;
        g_snake_buf[idx][0] = c.x;
        g_snake_buf[idx][1] = c.y;
        g_snake_buf[idx][2] = 0;
        idx++;
    }

    g_snake_buf[idx][0] = -1;
    g_snake_buf[idx][1] = -1;
    g_snake_buf[idx][2] = -1;

    return g_snake_rows;
}

int **SnakeInfoConverter::coordinateToArray(Coordinate c) {
    ensure_buffers();

    g_apple_buf[0][0] = c.x;
    g_apple_buf[0][1] = c.y;
    g_apple_buf[0][2] = 7;

    g_apple_buf[1][0] = -1;
    g_apple_buf[1][1] = -1;
    g_apple_buf[1][2] = -1;

    return g_apple_rows;
}
