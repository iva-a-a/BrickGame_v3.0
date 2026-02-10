//
//  SnakeInfoConverter.cpp
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//

#include "SnakeInfoConverter.h"

GameInfo_t SnakeInfoConverter::toGameInfo(const SnakeInfo info) {
    GameInfo_t out{};

    out.score = info.score;
    out.high_score = info.high_score;
    out.level = info.level;
    out.speed = info.speed;
    //out.pause = info.pause ? 1 : 0;
    // КОД ЭКРАНА в out.pause (GameInfo_t не меняем)
    if (info.score == 1000) {
      out.pause = 4;                 // WIN (по очкам, как ты просишь)
    } else if (info.state == Break) {
      out.pause = 1;                 // PAUSE
    } else if (info.state == Begin) {
      out.pause = 2;                 // START SCREEN
    } else if (info.state == End) {
      out.pause = 3;                 // GAME OVER
    } else if (info.state == Exit) {
      out.pause = 9;                 // EXIT
    } else {
      out.pause = 0;                 // RUNNING
    }

    out.next = listToArray(info.snake);
    out.field = coordinateToArray(info.apple);

    return out;
}

void SnakeInfoConverter::freeGameInfo(GameInfo_t& info) {
  freeArray(info.field);
  freeArray(info.next);

  info.field = nullptr;
  info.next = nullptr;
}

int **SnakeInfoConverter::listToArray(std::list<Coordinate> l) {
    int **arr = new int *[l.size() + 1];
    size_t index = 0;
    for (auto &i : l) {
      arr[index] = new int[3];
      arr[index][0] = i.x;
      arr[index][1] = i.y;
      arr[index][2] = 0;
      index++;
    }
    arr[index] = new int[3];
    arr[index][0] = -1;
    arr[index][1] = -1;
    arr[index][2] = -1;
    return arr;
}

int **SnakeInfoConverter::coordinateToArray(Coordinate c) {
    int **arr = new int *[2];
    size_t index = 0;

    arr[index] = new int[3];
    arr[index][0] = c.x;
    arr[index][1] = c.y;
    arr[index][2] = 7;
    index++;

    arr[index] = new int[3];
    arr[index][0] = -1;
    arr[index][1] = -1;
    arr[index][2] = -1;
    return arr;
}

void SnakeInfoConverter::freeArray(int **array) {
    if (array != nullptr) {
      size_t i = 0;
      while (array[i][0] != -1 && array[i][1] != -1 && array[i][2] != -1) {
        delete[] array[i];
        i++;
      }
      delete[] array[i];
      delete[] array;
    }
}
