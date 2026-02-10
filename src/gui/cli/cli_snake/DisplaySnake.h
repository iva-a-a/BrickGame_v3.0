#pragma once

#include "../../../brick_game/snake/wrapper/SnakeWrapper.h"
#include "../display.h"

class SnakeDisplay {

public:
  SnakeDisplay() = default;
  ~SnakeDisplay() = default;

  void game_snake();

private:
  void print_win();
  void printCurrentState(GameInfo_t info);
};
