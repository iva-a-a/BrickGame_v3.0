//
//  SnakeInfo.h
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//

#pragma once

#include "Coordinate.h"
#include "../api/struct.h"
#include <list>

struct SnakeInfo {
  GameState_t state;

  int score;
  int high_score;
  int level;
  int speed;
  bool pause;

  std::list<Coordinate> snake;
  Coordinate apple;
};
