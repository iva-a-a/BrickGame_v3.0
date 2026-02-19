#pragma once

#include <functional>

extern "C" {
#include "../../brick_game/struct.h"   // тут GameInfo_t и UserAction_t
}

struct GameApiQt {
  std::function<GameInfo_t(void)> update;
  std::function<void(UserAction_t, bool)> input;

  int beginSpeed = 1000;
  bool drawNext = false;   // tetris true
  bool useHold = false;    // snake true
};
