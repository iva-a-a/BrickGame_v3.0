#pragma once

#include <functional>

extern "C" {
#include "../../brick_game/api/struct.h"
}

struct GameApiQt {
  std::function<GameInfo_t(void)> update;
  std::function<void(UserAction_t, bool)> input;

  bool drawNext = false;  // tetris true
  bool useHold = false;   // snake true
};
