#pragma once

#include "../../../brick_game/snake/controller_snake.h"
#include "../display.h"

class SnakeDisplay {
 private:
  Controller *controller;

 public:
  explicit SnakeDisplay(Controller *c);

  ~SnakeDisplay() = default;

  void print_win();
  void printCurrentState(GameInfo_t &info);

  void game_snake();
};
