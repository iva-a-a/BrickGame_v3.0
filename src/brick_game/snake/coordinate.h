//
//  coordinate.h
//  BrickGame
//
//  Created by Alena Ivanova on 10.02.2026.
//
#pragma once
//#include <iostream>

struct Coordinate {
  int x;
  int y;

  bool eqCoordinate(const Coordinate &a) const {
    return (x == a.x && y == a.y);
  }

  bool operator==(const Coordinate &a) const { return eqCoordinate(a); }
};
